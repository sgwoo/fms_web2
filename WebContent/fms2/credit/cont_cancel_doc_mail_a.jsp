<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.net.URLEncoder, acar.util.*, tax.*"%>
<%@ page import="acar.im_email.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
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
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	String email 	= request.getParameter("email")==null?"":request.getParameter("email");
	
	boolean flag1 = true;

	int result = 0;
	
	String doc_id 	= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_nm 	= request.getParameter("gov_nm")==null?"":request.getParameter("gov_nm");
	String doc_title 	= request.getParameter("doc_title")==null?"":request.getParameter("doc_title");
	
			
	String subject 		= gov_nm+"님, (주)아마존카 채권 최고서 안내메일입니다.";
	String msg 			= gov_nm+"님, (주)아마존카 채권 최고서 안내메일입니다.";
	String sendname 	= "(주)아마존카";
	String sendphone 	= "02-392-4243";
	int seqidx			= 0;
	
	
	if(!email.equals("")){
			//	1. d-mail 등록-------------------------------
			DmailBean d_bean = new DmailBean();
			d_bean.setSubject			(subject);
			d_bean.setSql				("SSV:"+email.trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"아마존카\"<tax@amazoncar.co.kr>");
			d_bean.setMailto			("\""+gov_nm+"\"<"+email.trim()+">");
			d_bean.setReplyto			("\"아마존카\"<tax@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<tax@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				("credit");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin계정
			d_bean.setG_idx				(1);//admin계정
			d_bean.setMsgflag     		(0);
		
		   if ( doc_title.equals("계약해지 및 납부최고") ) {	
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel.jsp?doc_id="+URLEncoder.encode(doc_id,"EUC-KR"));
		   } else if ( doc_title.equals("계약해지 및 차량반납 통보")) {
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel_re.jsp?doc_id="+URLEncoder.encode(doc_id,"EUC-KR"));
		   }else if ( doc_title.equals("해지통보 및 해지정산금 납입고지")) {
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel_2.jsp?doc_id="+URLEncoder.encode(doc_id,"EUC-KR"));
		 
		   }
		//   System.out.println(doc_title);
		   seqidx = ImEmailDb.insertDEmail2(d_bean, "4", "", "+7");
	
				//	 email 주소 변경 
			int cnt1 = FineDocDb.updateFineDocEmail(doc_id, email);
			
	}

%>

<script>
<%	if(seqidx > 0){%>
			alert("정상적으로 처리되었습니다.");
				
<%		}else{%>
			alert("에러발생!");
<%		}%>

</script>

</body>
</html>