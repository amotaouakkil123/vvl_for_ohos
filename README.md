# Vulkan Validation Layer for OHOS

## Requirement:

- Clone the git repository from gitee: https://gitee.com/openharmony-sig/third_party_vulkan-validationlayers

## Build the Validation Layer

- Run the vvl_for_ohos.sh script from this repository and make sure to set the environment variables
to their correct destinations.

After compilation succeeds, you should find the libVkLayer_khronos_validation.so shared library in build-ohos/intermediate/layers.
The VkLayer_khronos_validation json file will be a json.in file that you can find in the layers directory (the one outside of build-ohos).
Rename the VkLayer_khronos_validation.json.in file to VkLayer_khronos_validation.json

## Flash .so and .json file to Huawei Phone
    hdc target mount
    hdc shell mkdir /system/etc/vulkan/implicit_layer.d/
    hdc file push VkLayer_khronos_validation.json /system/etc/vulkan/implicit_layer.d/
    hdc file push libVkLayer_khronos_validation.so /system/lib64
    hdc shell reboot

The validation layers should now be outputting information.