<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.tint.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*, acar.car_office.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
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
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
%>


<%
	String vid[] 	= request.getParameterValues("ch_cd");
	String vid_num 	= "";
	String tint_no 	= "";
	String off_id 	= "";
	String seq = "";
	int vid_size = vid.length;
	String value[] = new String[10];
	
	String req_code  = Long.toString(System.currentTimeMillis());
	
	out.println("선택건수="+vid_size+"<br><br>");
	
	for(int i=0;i < vid_size;i++){
	
		StringTokenizer st = new StringTokenizer(vid[i],"/");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		tint_no 		= value[0];
		off_id 	 		= value[1];		
		
		
		
		//용품관리
		TintBean tint 	= t_db.getCarTint(tint_no);
		
				
		//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		//문서품의
		DocSettleBean doc = d_db.getDocSettleCommi("6", tint.getDoc_code());
		
		String doc_bit 	= "4";
		String doc_step = "2";
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc.getDoc_no(), user_id, doc_bit, doc_step);
		out.println("문서처리전 결재<br>");



		//2. 용품의뢰 청구일자 수정-------------------------------------------------------------------------------------------
		
		if(!tint.getReg_st().equals("A") && !tint.getRent_l_cd().equals("")){
			TintBean tint1 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "1");
			TintBean tint2 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "2");
			TintBean tint3 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "3");
			TintBean tint4 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "4");
			TintBean tint5 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "5");	
			TintBean tint6 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "6");	

			//=====[tint] update=====
			if(off_id.equals(tint1.getOff_id())) 	flag1 = t_db.updateCarTintReqCode(tint1.getTint_no(), req_code);
			if(off_id.equals(tint2.getOff_id())) 	flag1 = t_db.updateCarTintReqCode(tint2.getTint_no(), req_code);
			if(off_id.equals(tint3.getOff_id())) 	flag1 = t_db.updateCarTintReqCode(tint3.getTint_no(), req_code);
			if(off_id.equals(tint4.getOff_id())) 	flag1 = t_db.updateCarTintReqCode(tint4.getTint_no(), req_code);
			if(off_id.equals(tint5.getOff_id())) 	flag1 = t_db.updateCarTintReqCode(tint5.getTint_no(), req_code);		
			if(off_id.equals(tint6.getOff_id())) 	flag1 = t_db.updateCarTintReqCode(tint6.getTint_no(), req_code);		
		}else{
			//=====[tint] update=====
			flag1 = t_db.updateCarTintReqCode(tint_no, req_code);	
		}						

	}
	
	
	Vector vt = t_db.getCarTintReqTarget(user_id, req_code);
	int vt_size = vt.size();
	
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		//3. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		String url 		= "/fms2/car_tint/tint_c_frame.jsp";
		String sub 		= "용품청구 확인";
		String cont 		= "용품청구되었습니다. 확인해 주십시오.";
		String target_id 	= String.valueOf(ht.get("USER_ID1"));
		String m_url ="/fms2/car_tint/tint_c_frame.jsp";
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
  					"    <CONT>"+cont+"</CONT>"+
  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		//받는사람
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		//보낸사람
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
		
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag3 = cm_db.insertCoolMsg(msg);
		
		System.out.println("쿨메신저(용품확인요청)-----------------------"+target_bean.getUser_nm());
		
		//4. SMS 문자 발송------------------------------------------------------------
		if(!target_bean.getUser_m_tel().equals("")){
			String sendphone 	= sender_bean.getHot_tel();
			String sendname 	= sender_bean.getUser_nm();
			
			String destphone 	= target_bean.getUser_m_tel();
			String destname 	= target_bean.getUser_nm();
			cont 	= "용품청구!확인바람. 확인완료후 대금지급됨.";
			
			//에이전트 실의뢰자한테 요청
			if(target_bean.getDept_id().equals("1000") && !String.valueOf(ht.get("AGENT_EMP_ID")).equals("")){
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(String.valueOf(ht.get("AGENT_EMP_ID")));
				destname 	= a_coe_bean.getEmp_nm();
				destphone = a_coe_bean.getEmp_m_tel();
			}
			
			
			IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", cont);
		}
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
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name="mode" 	value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>