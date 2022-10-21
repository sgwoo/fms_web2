package acar.kakao;

public class AlimTemplateBean {

    private int no;             // 템플릿 번호
    private String code;        // 템플릿 코드
    private String name;        // 템플릿 이름
    private String content;     // 템플릿 내용
    private String org_name;    // 발신 이름
    private String org_uuid;    // 발신 프로필 키
    private String desc;        // 설명
    private String category;    // 카테고리
    private String category_1;    // 카테고리_1
    private String showList;    // 템플릿 관리 여부
    private String use_yn;		// 템플릿 사용여부
    private String m_nm;		// 메뉴

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getOrg_name() {
        return org_name;
    }

    public void setOrg_name(String org_name) {
        this.org_name = org_name;
    }

    public String getOrg_uuid() {
        return org_uuid;
    }

    public void setOrg_uuid(String org_uuid) {
        this.org_uuid = org_uuid;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getCategory_1() {
        return category_1;
    }

    public void setCategory_1(String category_1) {
        this.category_1 = category_1;
    }

    public String getShowList() {
        return showList;
    }

    public void setShowList(String showList) {
        this.showList = showList;
    }

    public String getUse_yn() {
        return use_yn;
    }

    public void setUse_yn(String use_yn) {
        this.use_yn = use_yn;
    }
    
    public String getM_nm() {
    	return m_nm;
    }
    
    public void setM_nm(String m_nm) {
    	this.m_nm = m_nm;
    }

}
