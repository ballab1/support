package org.home.builds.compose;

import org.gradle.api.DefaultTask;
import org.gradle.api.tasks.TaskAction;

public class PdrBuild extends DefaultTask {

    private String message;
    private String recipient;

    public String getBuildTime() { return "."; }
    public String getFingerprint() { return "1"; }
    public String getGitRefs() { return "2"; }
    public String getGitCommit() { return "3"; }
    public String getGitUrl() { return "4"; }
    public String getOrigin() { return "5"; }
    public String getParent() { return "6"; }
    public String getCbfVersion() { return "7"; }



    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getRecipient() { return recipient; }
    public void setRecipient(String recipient) { this.recipient = recipient; }

    @TaskAction
    void sayGreeting() {
        System.out.printf("This is PdrBuild!\n");
    }
}