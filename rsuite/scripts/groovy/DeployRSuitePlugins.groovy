// Groovy script to clear workflows.

def projectDir = new File(scriptFile.absolutePath).parentFile.parentFile.parentFile.parentFile
def targetDir = new File(projectDir, "target");
def libDir = new File(new File(projectDir, "java"), "lib");



rsuite.login();


deployPlugin(new File(targetDir, "dita4publishers-rsuite-plugin.jar"));
rsuite.logout();

def deployPlugin(file) {
	println " + [INFO] Deploying ${file.getName()}...";
	rsuite.deployPlugin(file);
}
