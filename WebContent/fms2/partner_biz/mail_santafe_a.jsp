<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*,   acar.im_email.*, tax.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>

<%@ include file="/acar/cookies.jsp" %>
<% 
	FileUpload file = new FileUpload("C:\\Inetpub\\wwwroot\\data\\test\\", request.getInputStream());
	
	int count = 0;
	
	String auth_rw = file.getParameter("auth_rw")==null?"":file.getParameter("auth_rw");
	String br_id = file.getParameter("br_id")==null?"":file.getParameter("br_id");
	String user_id = file.getParameter("user_id")==null?"":file.getParameter("user_id");
	
	String s_kd = file.getParameter("s_kd")==null?"":file.getParameter("s_kd");
	String use_yn = file.getParameter("use_yn")==null?"Y":file.getParameter("use_yn");
	String t_wd = file.getParameter("t_wd")==null?"":file.getParameter("t_wd");
	String mail_title	= file.getParameter("mail_title")==null?"":file.getParameter("mail_title");
	String mail_cau		= file.getParameter("mail_cau")==null?"":file.getParameter("mail_cau");
	mail_cau = mail_cau.replace("\r\n", "<br>");
	
	String filename1 	= file.getFilename()			==null?"":file.getFilename();
	String filename2 	= file.getFilename2()			==null?"":file.getFilename2();
	String file_type 	= file.getFile_type()			==null?"":file.getFile_type();
	String file_type2 	= file.getFile_type2()			==null?"":file.getFile_type2();

	String user_mail	= file.getParameter("user_mail")==null?"":file.getParameter("user_mail");
	
	String subject 		= "";
	String msg 			= "";
	int seqidx			= 0;
	int idx				= 0;
	int fcnt = 0;
	
	//
	
	Vector vt =  ad_db.getSantafeCont();			
	int vt_size = vt.size();
			
	String mng_nm[] = new String[vt_size];
	String mng_pos[] = new String[vt_size];
	String mng_tel[] = new String[vt_size];
	String email[] = new String[vt_size];
			 
	//파싱		
	for(int i=0; i<vt_size;i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
	
		mng_nm[i] = (String)ht.get("USER_NM");
		mng_tel[i] = (String)ht.get("USER_M_TEL");
		mng_pos[i] = (String)ht.get("USER_POS");
		email[i] = (String)ht.get("CON_AGNT_EMAIL");
	//	System.out.println("mail=" + email[i]  );
	//  	email[i] = "dev@amazoncar.co.kr";
		
		subject 		= " 산타페 연비보상 관련 안내";
		msg 			= " 산타페 연비보상 관련 안내";
				

		//거래처 메일이 있으면
		if(!email[i].equals("")){
			//	1. d-mail 등록-------------------------------
			DmailBean d_bean = new DmailBean();
			d_bean.setSubject			(subject);
			d_bean.setSql				("SSV:"+email[i].trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"아마존카\"<tax@amazoncar.co.kr>");
			d_bean.setMailto			("\"고객\"<"+email[i].trim()+">");
			d_bean.setReplyto			("\"아마존카\"<tax@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<tax@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				("santafe");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin계정
			d_bean.setG_idx				(0);//admin계정
			d_bean.setMsgflag     		(0);	
			d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/etc/santafe_ind.jsp?mng_nm="+mng_nm[i]+"&mng_pos="+mng_pos[i]+"&mng_tel="+mng_tel[i]  );
												 
			seqidx = ImEmailDb.insertDEmail96(d_bean, "4", "", "+7");
			
		         count++;
				
		}
	}		

%>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(count >= 1){%>
	alert("발행되었습니다.");	
	top.window.close();

<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%}%>
//-->
</script>
</body>
</html>
