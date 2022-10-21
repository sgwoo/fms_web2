<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*, acar.estimate_mng.*, tax.* "%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String param 		= request.getParameter("param")==null?"":request.getParameter("param");
	String content_seq	= request.getParameter("content_seq")==null?"":request.getParameter("content_seq");
	String mail_title	= request.getParameter("mail_title")==null?"":request.getParameter("mail_title");
	String test_mail	= request.getParameter("test_mail")==null?"":request.getParameter("test_mail");
	String mail_st	= request.getParameter("mail_st")==null?"":request.getParameter("mail_st");
	
	CommonDataBase 		c_db = CommonDataBase.getInstance();
	AddClientDatabase 	acl_db = AddClientDatabase.getInstance();
	EstiDatabase 		e_db = EstiDatabase.getInstance();
	
	String content_code  = "RECALL";
	String param_arr[]	 = null;
	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	int result_cnt = 0;
	boolean flag = false;
	if(mode.equals("real")){
		if(!param.equals("")){ 
			param_arr = param.split(",");
	    	for(int i=0; i<param_arr.length;i++){
	    		Hashtable ht = acl_db.getClientOne(param_arr[i]);	
	    		
	    		//메일정보
	    		DmailBean d_bean = new DmailBean();
				d_bean.setSubject			(mail_title);
				d_bean.setSql				("SSV:"+ht.get("CON_AGNT_EMAIL"));
				d_bean.setReject_slist_idx	(0);
				d_bean.setBlock_group_idx	(0);
				d_bean.setMailfrom			("\"아마존카 발신전용\"<cs@amazoncar.co.kr>");
				d_bean.setMailto			("\""+ht.get("FIRM_NM")+"\"<"+ht.get("CON_AGNT_EMAIL")+">");
				d_bean.setReplyto			("\"(주)아마존카\"<cs@amazoncar.co.kr>");
				d_bean.setErrosto			("\"(주)아마존카\"<cs@amazoncar.co.kr>");
				d_bean.setHtml				(1);
				d_bean.setEncoding			(0);
				d_bean.setCharset			("euc-kr");
				d_bean.setDuration_set		(1);		
				d_bean.setClick_set			(0);
				d_bean.setSite_set			(0);
				d_bean.setAtc_set			(0);
				d_bean.setGubun				("리콜안내");
				d_bean.setRname				("mail");
				d_bean.setMtype       		(0);
				d_bean.setU_idx       		(1);//admin계정
				d_bean.setG_idx				(1);//admin계정
				d_bean.setMsgflag     		(0);
				if(mail_st.equals("2")){	// 캠페인 안내문
					d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/recall/service_email.jsp?content_seq="+content_seq+"&client_id="+ht.get("CLIENT_ID"));
				} else{
					d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/recall/recall_email.jsp?content_seq="+content_seq+"&client_id="+ht.get("CLIENT_ID"));
				}
				d_bean.setGubun2			(String.valueOf(ht.get("CLIENT_ID")));
				
				if(e_db.insertDEmail4(d_bean,"","+14")){
					result_cnt ++;
				}
	    	}
	    	if(param_arr.length == result_cnt)	 flag = true;
		}
	}else if(mode.equals("test")){	
	    		
   		//메일정보
   		DmailBean d_bean = new DmailBean();
		d_bean.setSubject			(mail_title);
		d_bean.setSql				("SSV:"+test_mail.trim());
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom			("\"아마존카 발신전용\"<cs@amazoncar.co.kr>");
		d_bean.setMailto			("\"테스트회사명\"<"+test_mail.trim()+">");
		d_bean.setReplyto			("\"(주)아마존카\"<cs@amazoncar.co.kr>");
		d_bean.setErrosto			("\"(주)아마존카\"<cs@amazoncar.co.kr>");
		d_bean.setHtml				(1);
		d_bean.setEncoding			(0);
		d_bean.setCharset			("euc-kr");
		d_bean.setDuration_set		(1);		
		d_bean.setClick_set			(0);
		d_bean.setSite_set			(0);
		d_bean.setAtc_set			(0);
		d_bean.setGubun				("리콜안내");
		d_bean.setRname				("mail");
		d_bean.setMtype       		(0);
		d_bean.setU_idx       		(1);//admin계정
		d_bean.setG_idx				(1);//admin계정
		d_bean.setMsgflag     		(0);
// 		d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/recall/recall_email.jsp?content_seq="+content_seq+"&client_id=019345");
		if(mail_st.equals("2")){	// 캠페인 안내문
			d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/recall/service_email.jsp?content_seq="+content_seq+"&client_id=019345");
		} else{
			d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/recall/recall_email.jsp?content_seq="+content_seq+"&client_id=019345");
		}
		//d_bean.setGubun2			(String.valueOf(ht.get("CLIENT_ID")));
		
		flag = e_db.insertDEmail4(d_bean,"","+14");
	}
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
</script>
</head>
<body>
<script type="text/javascript">
<%	if(flag == true){%>
	alert("정상적으로 처리되었습니다.");
<%}else{%>
	alert("처리되지 않았습니다\n\n에러발생!");
<%}%>
self.close();
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>

