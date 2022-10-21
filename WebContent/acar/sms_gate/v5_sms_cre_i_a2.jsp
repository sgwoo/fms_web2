<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*, acar.cont.*" %>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String destname 	= request.getParameter("destname")==null?"":request.getParameter("destname");
	String destphone 	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	
	String key_name = request.getParameter("key_name")==null?"":request.getParameter("key_name");	
	String birth_dt = request.getParameter("birth_dt")==null?"":request.getParameter("birth_dt");
	String eval_off = request.getParameter("eval_off")==null?"":request.getParameter("eval_off");
	String key_nice = request.getParameter("key_nice")==null?"":request.getParameter("key_nice");
	String key_kcb = request.getParameter("key_kcb")==null?"":request.getParameter("key_kcb");
	String key_m_tel = request.getParameter("destphone")==null?"":request.getParameter("destphone");
	
	String pk_key_no = request.getParameter("pk_key_no")==null?"":request.getParameter("pk_key_no");
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	
	//신용조회 대체키 등록
	
	boolean flag1 = true;
	
	if(!key_nice.equals("") || !key_kcb.equals("") || !pk_key_no.equals("")){
			
		ContEvalBean eval = new ContEvalBean();
		
		if(!pk_key_no.equals("")){		
			eval = a_db.getContEvalKey(pk_key_no);	
			
			key_m_tel = request.getParameter("key_m_tel")==null?"":request.getParameter("key_m_tel");		
		}else{
			eval.setKey_no		(reg_code);
		}
					
		eval.setKey_name	(key_name);
		eval.setKey_birth_dt	(birth_dt);
		eval.setKey_m_tel	(key_m_tel);
		eval.setKey_memo	(rent_l_cd);
		eval.setKey_nice	(key_nice);
		eval.setKey_kcb		(key_kcb);		
		
		if(!pk_key_no.equals("")){	
			
			reg_code = pk_key_no;
			
			//=====[CONT_EVAL_KEY] update=====
			flag1 = a_db.updateContEvalKey(eval);			
			
		}else{
			//중복값 체크후 등록한다		
			Vector vt = a_db.getContEvalKeyList(eval.getKey_name(), eval.getKey_birth_dt(), eval.getKey_m_tel());
			int vt_size = vt.size();
				
			if(vt_size==0){		
				//=====[CONT_EVAL_KEY] insert=====
				flag1 = a_db.insertContEvalKey(eval);			
			}else if(vt_size==1){
		
				Hashtable ht = (Hashtable)vt.elementAt(0);
						
				reg_code = String.valueOf(ht.get("KEY_NO"));
			
				//=====[CONT_EVAL_KEY] update=====
				flag1 = a_db.updateContEvalKey(eval);			
			}	

		}
		
	}	

	
	String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");
	String msg 		= request.getParameter("msg")==null?"":request.getParameter("msg");
	
	String msg_type 	= "5"; //장문자
	
	String no_num 	= request.getParameter("no_num")==null?"":request.getParameter("no_num");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String destphone2 = request.getParameter("destphone")==null?"":request.getParameter("destphone");
	if(no_num.equals("N")){
		destphone = "000-0000-0000";
		
	}
	
	UsersBean sender_bean = umd.getUsersBean(ck_acar_id);
	
	
	String sendname 	= sender_bean.getUser_nm();
	String sendphone 	= sender_bean.getUser_m_tel();
	
	if(!sender_bean.getHot_tel().equals("")){
		sendphone = sender_bean.getHot_tel();
	}
	
	String cmid = request.getParameter("cmid")==null?"":request.getParameter("cmid");
	String check = request.getParameter("check")==null?"":request.getParameter("check");
	String bus_id = request.getParameter("bus_id")==null?"":request.getParameter("bus_id");
	String score = request.getParameter("score")==null?"":request.getParameter("score");
	String score2 = request.getParameter("score2")==null?"":request.getParameter("score2");

	if(cmd.equals("u")){
		IssueDb.updatesendMail_V5_H2(cmid, ck_acar_id, bus_id, score, score2, destname, msg);
	}else{
		IssueDb.insertsendMail_V5_H2(sendphone, sendname, destphone, destname, "", "", msg_type, msg_subject, msg, firm_nm, client_id, ck_acar_id, destphone2, check, bus_id, score, score2, reg_code);
	}	
	
	
	
	

	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>
<script language="JavaScript">
<!--
	alert("신용조회 이력이 등록되었습니다.");
 	parent.location.reload();
//-->
</script>
</body>
</html>
