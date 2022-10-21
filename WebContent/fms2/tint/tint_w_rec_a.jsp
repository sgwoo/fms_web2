<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.tint.*, acar.doc_settle.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
%>


<%
	String vid[] 	= request.getParameterValues("ch_cd");
	String vid_num 	= "";
	String tint_no 	= "";
	String seq = "";
	int vid_size = vid.length;
	
	String req_code  = Long.toString(System.currentTimeMillis());
	
//	out.println("선택건수="+vid_size+"<br><br>");
	
	for(int i=0;i < vid_size;i++){
		
		vid_num = vid[i];
		
		tint_no 		= vid_num;
		
		//1. 용품의뢰 수정-------------------------------------------------------------------------------------------
		
		//용품관리
		TintBean tint 	= t_db.getTint(tint_no);
		
//		out.println("tint_no="+tint_no+"<br>");
//		out.println("reg_id="+tint.getReg_id()+"<br>");
		
		//2. 문서처리전 등록-------------------------------------------------------------------------------------------
		
		String sub 		= "용품의뢰";
		String cont 	= "[용품번호:"+tint_no+"] 용품의뢰 합니다.";
		String target_id = user_id;
		
		if(tint.getOff_id().equals("002849")) 						target_id = "000103";				//다옴방
		if(tint.getOff_id().equals("002850")) 						target_id = nm_db.getWorkAuthUser("부산출납");	//유림카랜드-부산출납
		if(tint.getOff_id().equals("008692")) 						target_id = nm_db.getWorkAuthUser("대전지점장");//오토카샵-대전지점장
		if(tint.getOff_id().equals("008501")) 						target_id = nm_db.getWorkAuthUser("부산출납");	//아시아나상사-부산출납

				
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st("6");//용품의뢰
		doc.setDoc_id(tint_no);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc("");
		doc.setUser_nm1("의뢰");
		doc.setUser_nm2("수신");
		doc.setUser_nm3("정산");
		doc.setUser_nm4("청구");
		doc.setUser_nm5("확인");
		doc.setUser_nm6("점검");
		doc.setUser_id1(tint.getReg_id());
		doc.setUser_id2(target_id);
		doc.setUser_id3(target_id);
		doc.setUser_id4(target_id);
		doc.setUser_id5(tint.getReg_id());
		doc.setDoc_bit("1");//수신단계
		doc.setDoc_step("1");//기안
		
		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
		
		
		//=====[doc_settle] update=====
		doc = d_db.getDocSettleCommi("6", tint_no);
		flag2 = d_db.updateDocSettle(doc.getDoc_no(), target_id, "2", "2");
		out.println("문서처리전 결재<br>");
		
		
		System.out.println("쿨메신저(용품의뢰)-----------------------"+br_id);
		
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('용품 수정 에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 				value="<%=mode%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>