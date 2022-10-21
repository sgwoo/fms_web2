<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.ext.*, acar.bill_mng.*, acar.common.*, tax.*, acar.user_mng.*, acar.res_search.*"%>
<%@ page import="acar.con_ins_m.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id 	= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	String s_cd 	= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");	
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String tm 	= request.getParameter("tm")==null?"":request.getParameter("tm");	
	
	
	String tax_branch= request.getParameter("tax_branch")==null?"S1":request.getParameter("tax_branch");
	String enp_no	= request.getParameter("enp_no")==null?"":request.getParameter("enp_no");
	String ssn	= request.getParameter("ssn")==null?"":request.getParameter("ssn");
	String bigo	= request.getParameter("bigo")==null?"":request.getParameter("bigo");
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	int flag = 0;
	int flag2 = 0;
	int flag3 = 0;
	boolean u_flag = true;
	
	ScdRentBean sr_bean = rs_db.getScdRentCase(s_cd, rent_st, tm);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	
	//소속영업소 리스트 조회
	Hashtable br = c_db.getBranch("S1");  //무조건 본사
	
	//전자입금표일련번호
	String SeqId = IssueDb.getSeqIdNext("PayEBill","PE");
	System.out.println("기본식정비대차 입금표=" + SeqId);
	
		SaleEBillBean sb_bean = new SaleEBillBean();
		
		sb_bean.setSeqID		(SeqId);
		sb_bean.setDocCode		("03");
		sb_bean.setDocKind		("03");
		sb_bean.setS_EbillKind		("1");//1:일반입금표 2:위수탁입금표
		sb_bean.setRefCoRegNo		("");
		sb_bean.setRefCoName		("");
		sb_bean.setTaxSNum1		("");
		sb_bean.setTaxSNum2		("");
		sb_bean.setTaxSNum3		("");
		sb_bean.setDocAttr		("N");
		sb_bean.setOrigin		("");
		sb_bean.setPubDate		(sr_bean.getPay_dt());
		sb_bean.setSystemCode		("KF");
		//공급자------------------------------------------------------------------------------
		sb_bean.setMemID		("amazoncar11");
		sb_bean.setMemName		(user_bean.getUser_nm());
		sb_bean.setEmail		("tax@amazoncar.co.kr");				//계산서 담당 메일 주소
		sb_bean.setTel			(user_bean.getHot_tel());
		sb_bean.setCoRegNo		(String.valueOf(br.get("BR_ENT_NO")));
		sb_bean.setCoName		("(주)아마존카");
		sb_bean.setCoCeo		(String.valueOf(br.get("BR_OWN_NM")));
		sb_bean.setCoAddr		(String.valueOf(br.get("BR_ADDR")));
		sb_bean.setCoBizType		(String.valueOf(br.get("BR_STA")));
		sb_bean.setCoBizSub		(String.valueOf(br.get("BR_ITEM")));
		//공급받는자--------------------------------------------------------------------------
		sb_bean.setRecMemID		("");
		sb_bean.setRecMemName		(request.getParameter("agnt_nm")==null?"":request.getParameter("agnt_nm"));
		sb_bean.setRecEMail		(request.getParameter("agnt_email")==null?"":request.getParameter("agnt_email"));
		sb_bean.setRecTel		(request.getParameter("tel")==null?"":request.getParameter("tel"));
		//공급받는자가 개인일때와 법인일대의 처리
				
		sb_bean.setRemarks		(bigo+  "-" + l_cd );
		sb_bean.setRecCoRegNo		(enp_no);
		
		sb_bean.setRecCoName		(request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm"));
		sb_bean.setRecCoCeo		(request.getParameter("client_nm")==null?"":request.getParameter("client_nm"));
		sb_bean.setRecCoAddr		(request.getParameter("addr")==null?"":request.getParameter("addr"));
		sb_bean.setRecCoBizType		(request.getParameter("i_sta")==null?"":request.getParameter("i_sta"));
		sb_bean.setRecCoBizSub		(request.getParameter("i_item")==null?"":request.getParameter("i_item"));
		sb_bean.setSupPrice		(sr_bean.getPay_amt());
		sb_bean.setTax			(0);
		sb_bean.setPubKind		("N");
		sb_bean.setLoadStatus		(0);
		sb_bean.setPubCode		("");
		sb_bean.setPubStatus		("");
		
		if(!IssueDb.insertPayEBill(sb_bean)){
			flag3 += 1;		
		}		
%>
<html>
<head><title>FMS</title></head>
<body>
<form name='form1' action='' method="POST">
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>

<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='idx' value='<%=idx%>'>

<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>
<input type='hidden' name='serv_id' value='<%=serv_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='tm' value='<%=tm%>'>
</form>
<script language='javascript'>
<%	if(flag3 == 1){%>
		alert('입금표발행 오류발생!');
		location='about:blank';	
<%	}else{%>
		alert('처리되었습니다');
		document.form1.action='con_s_rent2_c.jsp';		
		document.form1.target='d_content';
		document.form1.submit();
		parent.close();
<%	}%>
</script>
</body>
</html>
