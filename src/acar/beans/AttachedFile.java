package acar.beans;
/**
 * ÷������
 * @author dev.ywkim
 *
 */
public class AttachedFile {
	
	/** ÷������ ������ **/
	private int seq;
	
	/** ������ �ڵ� **/
	private String contentCode;
	
	/** ������ ������ **/
	private String contentSeq;
	
	/** ���� ���ϸ� **/
	private String fileName;
	
	/** ���� ������ **/
	private long fileSize;
	
	/** ���� Ÿ�� **/
	private String fileType;
	
	/** �������ϸ� **/
	private String saveFile;
	
	/** ���������� **/
	private String saveFolder;
	
	/** �ۼ��� **/
	private String regUser;
	
	/** ����� **/
	private String regDate;
	
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getContentCode() {
		return contentCode;
	}
	public void setContentCode(String contentCode) {
		this.contentCode = contentCode;
	}
	public String getContentSeq() {
		return contentSeq;
	}
	public void setContentSeq(String contentSeq) {
		this.contentSeq = contentSeq;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public long getFileSize() {
		return fileSize;
	}
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getSaveFile() {
		return saveFile;
	}
	public void setSaveFile(String saveFile) {
		this.saveFile = saveFile;
	}
	public String getSaveFolder() {
		return saveFolder;
	}
	public void setSaveFolder(String saveFolder) {
		this.saveFolder = saveFolder;
	}
	public String getRegUser() {
		return regUser;
	}
	public void setRegUser(String regUser) {
		this.regUser = regUser ;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
}
