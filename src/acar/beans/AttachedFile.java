package acar.beans;
/**
 * 첨부파일
 * @author dev.ywkim
 *
 */
public class AttachedFile {
	
	/** 첨부파일 시퀀스 **/
	private int seq;
	
	/** 컨텐츠 코드 **/
	private String contentCode;
	
	/** 컨텐츠 시퀀스 **/
	private String contentSeq;
	
	/** 실제 파일명 **/
	private String fileName;
	
	/** 파일 사이즈 **/
	private long fileSize;
	
	/** 파일 타입 **/
	private String fileType;
	
	/** 저장파일명 **/
	private String saveFile;
	
	/** 저장폴더명 **/
	private String saveFolder;
	
	/** 작성자 **/
	private String regUser;
	
	/** 등록일 **/
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
