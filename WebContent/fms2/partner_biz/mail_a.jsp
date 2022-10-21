<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.im_email.*, tax.*"%>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="pd_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<% 

	FileUpload file = new FileUpload("/httpd/www/data/test/", request.getInputStream());
	
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

   	int  vid_size		= file.getParameter("vid_size")==null?0:Integer.parseInt(file.getParameter("vid_size"));
   	   	
	String user_mail[] = file.getParameterValues("user_mail");       //메일
	
	mail_title=new String(mail_title.getBytes("8859_1"),"euc-kr");  
	
	//System.out.println("s_kd: "+s_kd);
	//System.out.println("mail_title: "+mail_title);
   //	System.out.println( "vid_size=" + vid_size );	
 	      				
	String subject 		= "";
	String msg 			= "";
	int seqidx			= 0;
	int idx				= 0;
	int fcnt = 0;
	
	if(!filename1.equals("")){
		fcnt ++;
	}
	if(!filename2.equals("")){
		fcnt ++;
	}

      // loop       
  
   for(int k=0; k<user_mail.length;k++) {
      	
 //     	user_maill 	= file.getParameter("user_mail" + k )==null?"":file.getParameter("user_mail"+k);
      	System.out.println(user_mail[k]);		  	
   		
		Vector vt = new Vector();
			
		vt = pd_db.getFinMan2(s_kd, use_yn, "S", user_mail[k]);
			

		int vt_size = vt.size();
		
		String fileinfo ="";
		String firm_nm[] = new String[vt_size];
		String mng_nm[] = new String[vt_size];
		String email[] = new String[vt_size];
				 
		//파싱
		
		for(int i=0; i<vt_size;i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			firm_nm[i] = (String)ht.get("COM_NM");
			mng_nm[i] =  (String)ht.get("AGNT_NM")+" "+(String)ht.get("AGNT_TITLE");
			email[i] = (String)ht.get("FIN_EMAIL");
		  //email[i] = "dev@amazoncar.co.kr";
			
			subject 		= mail_title;
			msg 			= mail_title;
					
	
			//거래처 메일이 있으면
			if(!email[i].equals("")){
				//	1. d-mail 등록-------------------------------
				DmailBean d_bean = new DmailBean();
				d_bean.setSubject			(subject);
				d_bean.setSql				("SSV:"+email[i].trim());
				d_bean.setReject_slist_idx	(0);
				d_bean.setBlock_group_idx	(0);
				d_bean.setMailfrom			("\"아마존카\"<tax@amazoncar.co.kr>");
				d_bean.setMailto			("\""+mng_nm[i]+"\"<"+email[i].trim()+">");
				d_bean.setReplyto			("\"아마존카\"<tax@amazoncar.co.kr>");
				d_bean.setErrosto			("\"아마존카\"<tax@amazoncar.co.kr>");
				d_bean.setHtml				(1);
				d_bean.setEncoding			(0);
				d_bean.setCharset			("euc-kr");
				d_bean.setDuration_set		(1);
				d_bean.setClick_set			(0);
				d_bean.setSite_set			(0);
				d_bean.setAtc_set			(fcnt);
				d_bean.setGubun				("partner_mail");
				d_bean.setRname				("mail");
				d_bean.setMtype       		(0);
				d_bean.setU_idx       		(1);//admin계정
				d_bean.setG_idx				(fcnt);//admin계정
				d_bean.setMsgflag     		(0);	
				d_bean.setContent			(mail_cau);//메일 내용
								 
				seqidx = ImEmailDb.insertDEmail96(d_bean, "4", "", "+7");
	
			    count++;
				
				for(int j=1; j <=fcnt; j++){
					if(j == 1){ 
				
						if(!filename1.equals("")){
							 fileinfo = filename1+file_type;	
						//	  System.out.println("fileinfo=" + fileinfo); 
						}
					}
					if(j == 2){ 
						if(!filename2.equals("")){
							 fileinfo = filename2+file_type2;
						//	  System.out.println("fileinfo2=" + fileinfo); 
						}
					}
					
					String content = "http://fms1.amazoncar.co.kr/data/test/"+fileinfo;
					
					idx = ImEmailDb.insertDEmailEnc96("partner_mail", fileinfo, content);			
					
				}
			}		
	  
		}	
	
	}	// end loop
	
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
