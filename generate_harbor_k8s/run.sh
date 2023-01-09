#!/bin/bash
# 注意: harbor 默认 ingress 不限制上传大小,需要修改请参考 http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size
base_path=$(cd `dirname $0`;pwd)
VERSION=v1.10.2
WORKDIR=${base_path}/tmp
domain=hub.l-xh.com # 对外访问域名
harbor_helm_dir=
rm -rf ${WORKDIR}
# 下载官方安装包
wget -P ${WORKDIR} https://github.com/goharbor/harbor-helm/archive/refs/tags/${VERSION}.tar.gz
tar -zxvf ${WORKDIR}/${VERSION}.tar.gz -C ${WORKDIR}
# 更新 Harbor helm 配置
harbor_helm_dir=$(ls -d ${WORKDIR}/* | grep harbor-helm)
# 设置访问模式为 nodePort, 查看匹配 sed -n '/type: ingress/p' values.yaml
sed -i "" 's/type: ingress/type: nodePort/g' ${harbor_helm_dir}/values.yaml
# 设置外部访问 URL externalURL 为 ${domain}, 查看匹配 sed -n '/^externalURL: .*/p' values.yaml
sed -i "" "s#^externalURL: .*#externalURL: https://${domain}:30003#g" ${harbor_helm_dir}/values.yaml
# 设置证书域名 ${domain}, 如果使用了自定义外部访问地址或者关闭了 ingress 访问模式,必须设置, 查看匹配 sed -n '/commonName: .*/p' values.yaml
sed -i "" "s#commonName: .*#commonName: ${domain}#g" ${harbor_helm_dir}/values.yaml
# 设置证书域名 ${domain} 查看匹配 sed -n '/core: .*/p' values.yaml
sed -i "" "s#core: .*#core: ${domain}#g" ${harbor_helm_dir}/values.yaml
# 关闭自动创建卷, 查看匹配 sed -n '/storageClass: .*/p' values.yaml
sed -i "" 's#storageClass: .*#storageClass: "-"#g' ${harbor_helm_dir}/values.yaml
# 设置自定义卷, 查看匹配 sed -n '/existingClaim: .*/p' values.yaml
sed -i "" 's#existingClaim: .*#existingClaim: harbor-pvc#g' ${harbor_helm_dir}/values.yaml
# 设置子卷, 注意: 此处必须按顺序执行, 查看匹配 grep -n 'subPath: ""' values.yaml
grep -n 'subPath: ""' ${harbor_helm_dir}/values.yaml | awk -F: '{print $1}' | sed -n '1p' | xargs -I{} sed -i "" '{}s/subPath: ""/subPath: "registry"/g' ${harbor_helm_dir}/values.yaml
grep -n 'subPath: ""' ${harbor_helm_dir}/values.yaml | awk -F: '{print $1}' | sed -n '1p' | xargs -I{} sed -i "" '{}s/subPath: ""/subPath: "chartmuseum"/g' ${harbor_helm_dir}/values.yaml
grep -n 'subPath: ""' ${harbor_helm_dir}/values.yaml | awk -F: '{print $1}' | sed -n '1p' | xargs -I{} sed -i "" '{}s/subPath: ""/subPath: "job-logs"/g' ${harbor_helm_dir}/values.yaml
grep -n 'subPath: ""' ${harbor_helm_dir}/values.yaml | awk -F: '{print $1}' | sed -n '1p' | xargs -I{} sed -i "" '{}s/subPath: ""/subPath: "job-scandata-exports"/g' ${harbor_helm_dir}/values.yaml
grep -n 'subPath: ""' ${harbor_helm_dir}/values.yaml | awk -F: '{print $1}' | sed -n '1p' | xargs -I{} sed -i "" '{}s/subPath: ""/subPath: "database"/g' ${harbor_helm_dir}/values.yaml
grep -n 'subPath: ""' ${harbor_helm_dir}/values.yaml | awk -F: '{print $1}' | sed -n '1p' | xargs -I{} sed -i "" '{}s/subPath: ""/subPath: "redis"/g' ${harbor_helm_dir}/values.yaml
grep -n 'subPath: ""' ${harbor_helm_dir}/values.yaml | awk -F: '{print $1}' | sed -n '1p' | xargs -I{} sed -i "" '{}s/subPath: ""/subPath: "trivy"/g' ${harbor_helm_dir}/values.yaml
# 生成部署的 yaml 文件, 注意: 如果不想要前缀,必须使用 harbor
helm install harbor ${harbor_helm_dir} --dry-run --debug > ${WORKDIR}/deploy.yaml
# 去掉无用内容
sed -n '/^HOOKS:/,/^NOTES:/p' ${WORKDIR}/deploy.yaml > ${base_path}/deploy.yaml
# 查看匹配 sed -n '/custom-.*/p' deploy.yaml
# sed -i "" 's/custom-//g' ${base_path}/deploy.yaml
# 查看匹配 sed -n '/^HOOKS:/p' deploy.yaml
sed -i "" '/^HOOKS:/d' ${base_path}/deploy.yaml
# 查看匹配 sed -n '/^MANIFEST:/p' deploy.yaml
sed -i "" '/^MANIFEST:/d' ${base_path}/deploy.yaml
# 查看匹配 sed -n '/^NOTES:/p' deploy.yaml
sed -i "" '/^NOTES:/d' ${base_path}/deploy.yaml
# 查看匹配 sed -n '/heritage/p' deploy.yaml
sed -i "" '/heritage/d' ${base_path}/deploy.yaml
# 查看匹配 sed -n '/release:/p' deploy.yaml
sed -i "" '/release:/d' ${base_path}/deploy.yaml
# 查看匹配 sed -n '/chart:/p' deploy.yaml
sed -i "" '/chart:/d' ${base_path}/deploy.yaml
# 查看匹配 sed -n '/helm.sh\/resource-policy/p' deploy.yaml
sed -i "" '/helm.sh\/resource-policy/d' ${base_path}/deploy.yaml
# 查看匹配 sed -n '/checksum/p' deploy.yaml
sed -i "" '/checksum/d' ${base_path}/deploy.yaml
# 查看匹配 sed -n '/component/p' deploy.yaml
#sed -i "" '/component/d' ${base_path}/deploy.yaml

# 清理目录
echo "清理目录..."
cp ${WORKDIR}/deploy.yaml ${base_path}/deploy-origin.yaml
#rm -rf ${WORKDIR}
echo "kubernetes yaml 生成完毕,请查看${base_path}/deploy.yaml"