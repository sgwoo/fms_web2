<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, java.net.*, tax.*, acar.estimate_mng.*, acar.user_mng.*,acar.im_email.*" %>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<% 
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String mail_addr 	= request.getParameter("mail_addr")==null?"":request.getParameter("mail_addr");
	int    est_size 	= request.getParameter("est_size")==null?0:AddUtil.parseInt(request.getParameter("est_size"));
	
	String replyto_st 	= request.getParameter("replyto_st")==null?"1":request.getParameter("replyto_st");
	String replyto 		= request.getParameter("replyto")==null?"":request.getParameter("replyto");
	
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");

	String est_nm 		= request.getParameter("memo")==null?"고객":request.getParameter("est_nm");
	//[개인신용정보 조회동의] 첨부 여부
	String file_add_yn1 	= request.getParameter("file_add_yn1")	==null?"":request.getParameter("file_add_yn1");

		//[사업자등록증] 첨부 여부
	String file_add_yn2 	= request.getParameter("file_add_yn2")	==null?"":request.getParameter("file_add_yn2");
	
	String send_seq = request.getParameter("send_seq")==null?"":request.getParameter("send_seq");	

	
	int count = 0;
	
	System.out.println("ARS 결제안내 메일발송 : mail_addr="+mail_addr);
	
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	String mail_dyr_ggr = request.getParameter("mail_dyr_ggr")==null?"":request.getParameter("mail_dyr_ggr");	
	String mail_etc_ycr = request.getParameter("mail_etc_ycr")==null?"":request.getParameter("mail_etc_ycr");	
	String mail_dyr_bgs = request.getParameter("mail_dyr_bgs")==null?"":request.getParameter("mail_dyr_bgs");	
	String mail_etc_gtr = request.getParameter("mail_etc_gtr")==null?"":request.getParameter("mail_etc_gtr");	
	String mail_etc_hap = request.getParameter("mail_etc_hap")==null?"":request.getParameter("mail_etc_hap");	
	String mail_dyr_hap = request.getParameter("mail_dyr_hap")==null?"":request.getParameter("mail_dyr_hap");	
	String settle_mny = request.getParameter("settle_mny")==null?"":request.getParameter("settle_mny");	
	String card_fee = request.getParameter("card_fee")==null?"":request.getParameter("card_fee");	
	String kj_ggr = request.getParameter("kj_ggr")==null?"":request.getParameter("kj_ggr");	
	String kj_bgs = request.getParameter("kj_bgs")==null?"":request.getParameter("kj_bgs");	
	String good_mny = request.getParameter("good_mny")==null?"":request.getParameter("good_mny");
	String card_per = request.getParameter("card_per")==null?"":request.getParameter("card_per");
	

	
	
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	
	String user_email = "";
	user_email = "sales@amazoncar.co.kr";
	
	if(replyto_st.equals("1")){
			replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
	}else if(replyto_st.equals("2")){
		if(!user_id.equals("")){
			replyto = "\"아마존카 "+user_bean.getUser_nm()+"\"<"+user_bean.getUser_email()+">";
		}else{
			replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
		}
	}else if(replyto_st.equals("3")){
		if(!replyto.equals("")){
			if(!user_id.equals("")){
				replyto = "\"아마존카 "+user_bean.getUser_nm()+"\"<"+replyto+">";
			}else{
				replyto = "\"아마존카\"<"+replyto+">";
			}
		}else{
			replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
		}
	}
	
	DmailBean d_bean = new DmailBean();
	d_bean.setSubject			("[아마존카 - ARS 결제 안내] "+est_nm+" 님의 ARS 결제 안내입니다.");
	d_bean.setSql				("SSV:"+mail_addr.trim());
	d_bean.setReject_slist_idx	(0);
	d_bean.setBlock_group_idx	(0);
	d_bean.setMailfrom			(replyto);
	d_bean.setMailto			("\""+est_nm+"\"<"+mail_addr.trim()+">");
	d_bean.setReplyto			("\"아마존카\"<no-reply@amazoncar.co.kr>");
	d_bean.setErrosto			("\"아마존카\"<return@amazoncar.co.kr>");	
	d_bean.setHtml				(1);
	d_bean.setEncoding			(0);
	d_bean.setCharset			("euc-kr");
	d_bean.setDuration_set		(1);
	d_bean.setClick_set			(0);
	d_bean.setSite_set			(0);
	d_bean.setAtc_set			(0);
	d_bean.setGubun				("ars");
	d_bean.setRname				("mail");
	d_bean.setMtype       		(0);
	d_bean.setU_idx       		(1);//admin계정
	d_bean.setG_idx				(1);//admin계정
	d_bean.setMsgflag     		(0);
	d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/off_doc/select_ars_email_docs.jsp?user_id="+user_id+"&est_nm="+URLEncoder.encode(est_nm, "EUC-KR")+"&memo="+URLEncoder.encode(memo, "EUC-KR")+"&mail_dyr_ggr="+mail_dyr_ggr+"&mail_etc_ycr="+mail_etc_ycr+"&mail_dyr_bgs="+mail_dyr_bgs+"&mail_etc_gtr="+mail_etc_gtr+"&mail_etc_hap="+mail_etc_hap+"&mail_dyr_hap="+mail_dyr_hap+"&settle_mny="+settle_mny+"&card_fee="+card_fee+"&kj_ggr="+kj_ggr+"&kj_bgs="+kj_bgs+"&good_mny="+good_mny+"&card_per="+card_per); 
	
	

	boolean flag = ImEmailDb.insertDEmail(d_bean, "4", "", "+7"); 
	

	

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--
<%if(flag){%>
	alert("메일이 정상적으로 발송 되었습니다.");
	parent.window.close();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	parent.window.close();				
<%}%>
//-->
</script>

</body>
</html>



