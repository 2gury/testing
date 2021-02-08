
struct proc_dir_entry *proc_create(
    const char *name, umode_t mode, struct proc_dir_entry *parent,
    const struct file_operations *proc_fops);

void proc_remove(struct proc_dir_entry *entry);

static struct file_operations process_sched_add_module_fops = {
	.owner =	THIS_MODULE,
	.read =		process_sched_add_module_read,
	.write =	process_sched_add_module_write,
	.open =		process_sched_add_module_open,
	.release =	process_sched_add_module_release,
};
