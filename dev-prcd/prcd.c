#include <linux/fs.h>
#include <linux/init.h>
#include <linux/device.h>
#include <linux/miscdevice.h>
#include <linux/module.h>
#include <linux/gpio.h>
#include <linux/of.h>
#include <linux/of_gpio.h>
#include <asm/uaccess.h>
#include <asm/delay.h>
#include <linux/random.h>
#include "bestemmie.h"

static ssize_t prcd_dev_read(struct file *filep, char *buffer, size_t len, loff_t *offset);

static const struct file_operations prcd_fops = {
  .owner = THIS_MODULE,
  .read = prcd_dev_read
};

static struct miscdevice prcd_dev = {
  MISC_DYNAMIC_MINOR,
  "prcd",
  &prcd_fops
};

static ssize_t prcd_dev_read(struct file *filep, char *buffer, size_t len, loff_t *offset) {
  uint i;
  int  count;
  get_random_bytes(&i, sizeof(i));
  printk(KERN_INFO "%i\n",i);
  i = i % N_BESTEMMIE;
  printk(KERN_INFO "%i\n",i);
  count = strlen(bestemmie[i]);

  if (len < count)
    return -EINVAL;

  if (*offset != 0)
    return 0;

  if (copy_to_user(buffer, bestemmie[i], count))
    return -EINVAL;

  *offset = count;

  return count;
}

static int __init prcd_init(void) {
  int ret;
  ret = misc_register(&prcd_dev);
  
  if(ret) {
    printk(KERN_ERR "Unable to register prcd device\n");
    return ret;
  }          
  return ret;
}

static void __exit prcd_exit(void) {
  misc_deregister(&prcd_dev);
}

module_init(prcd_init);
module_exit(prcd_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("encrypt <encrypt@labr.xyz>");
MODULE_DESCRIPTION("prcd in kernel");
MODULE_VERSION("0.1");
