<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.net.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.admin.*,  acar.im_email.*, tax.*"%>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 			= request.getParameter("auth_rw")			==null?"":request.getParameter("auth_rw");
	String user_id 			= request.getParameter("user_id")			==null?ck_acar_id:request.getParameter("user_id");
	String br_id 				= request.getParameter("br_id")  			==null?acar_br:request.getParameter("br_id");
	
	String s_kd 				= request.getParameter("s_kd")				==null?"":request.getParameter("s_kd");
	String t_wd 				= request.getParameter("t_wd")				==null?"":request.getParameter("t_wd");
	String andor 				= request.getParameter("andor")				==null?"":request.getParameter("andor");
	String gubun1 			= request.getParameter("gubun1")			==null?"":request.getParameter("gubun1");
	String gubun2 			= request.getParameter("gubun2")			==null?"":request.getParameter("gubun2");
	String gubun3 			= request.getParameter("gubun3")			==null?"":request.getParameter("gubun3");
	String from_page 		= request.getParameter("from_page")		==null?"":request.getParameter("from_page");
	
	String email 				= request.getParameter("email")				==null?"":request.getParameter("email");
	String notice_title 		= request.getParameter("notice_title")		==null?"":request.getParameter("notice_title");
	String file_size3 		= request.getParameter("file_size3")		==null?"":request.getParameter("file_size3");
	String file_type3 		= request.getParameter("file_type3")		==null?"":request.getParameter("file_type3");
	String seq3 				= request.getParameter("seq3")				==null?"":request.getParameter("seq3");
	
	String vio_pla 		= request.getParameter("vio_pla") 		== null ? "" : request.getParameter("vio_pla");
	String vio_dt 			= request.getParameter("vio_dt") 			== null ? "" : request.getParameter("vio_dt");
	String vio_st 			= request.getParameter("vio_st") 			== null ? "" : request.getParameter("vio_st");
	String vio_cont 		= request.getParameter("vio_cont") 		== null ? "" : request.getParameter("vio_cont");

	// String fine_st			= request.getParameter("fine_st") 			== null ? "" : request.getParameter("fine_st");
	// String notice_dt 		= request.getParameter("notice_dt") 		== null ? "" : request.getParameter("notice_dt");
	// String paid_no 		= request.getParameter("paid_no") 		== null ? "" : request.getParameter("paid_no");
	// String obj_end_dt 	= request.getParameter("obj_end_dt") 	== null ? "" : request.getParameter("obj_end_dt");
	// String doc_id 			= request.getParameter("doc_id") 			== null ? "" : request.getParameter("doc_id");
	// String doc_dt	 		= request.getParameter("doc_dt") 			== null ? "" : request.getParameter("doc_dt");
	// String print_dt 		= request.getParameter("print_dt") 		== null ? "" : request.getParameter("print_dt");
	// String obj_dt1 		= request.getParameter("obj_dt1") 		== null ? "" : request.getParameter("obj_dt1");
	// String obj_dt2 		= request.getParameter("obj_dt2") 		== null ? "" : request.getParameter("obj_dt2");
	// String obj_dt3 		= request.getParameter("obj_dt3") 		== null ? "" : request.getParameter("obj_dt3");

	int flag1 = 0;
	int result = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();

	//과태료정보
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	String m_id 			= request.getParameter("m_id")			==null?"":request.getParameter("m_id");
	String l_cd 			= request.getParameter("l_cd")			==null?"":request.getParameter("l_cd");
	String c_id 			= request.getParameter("c_id")			==null?"":request.getParameter("c_id");
	String seq_no 		= request.getParameter("seq_no")		==null?"":request.getParameter("seq_no");		
	String firm_nm 		= request.getParameter("firm_nm")		==null?"":request.getParameter("firm_nm");
	String res_firm 		= request.getParameter("res_firm")		==null?"":request.getParameter("res_firm");
	
	String dem_dt 		= request.getParameter("dem_dt")		==null?"":request.getParameter("dem_dt");
	String e_dem_dt 	= request.getParameter("e_dem_dt")	==null?"":request.getParameter("e_dem_dt");
	String gov_id 		= request.getParameter("gov_id")		==null?"":request.getParameter("gov_id");
		
	String subject 		= "";
	String msg 			= "";
	String mms 			= "";
	String sendname 	= "(주)아마존카";
	String sendphone 	= "02-392-4242";
	int seqidx				= 0;	
	
	String gov_nm 		= "";
	gov_nm = firm_nm;
	
	if (!res_firm.equals("") ) {
		gov_nm = res_firm;
	}	
	
	String file_name1 = request.getParameter("file_name")==null?"":request.getParameter("file_name");
	String file_name2 = request.getParameter("file_name2")==null?"":request.getParameter("file_name2");
	int idx			= 0;	
	int fcnt = 0;
	if(!file_name1.equals("")){
		fcnt ++;
	}
	if(!file_name2.equals("")){
		fcnt ++;
	}

	dem_dt = AddUtil.getReplace_dt(dem_dt);
	
	e_dem_dt = AddUtil.getDate(); //최종수정일로갱신됨. 
	e_dem_dt = AddUtil.getReplace_dt(e_dem_dt);
	
	// 과태료에 발송일 저장
	if(!a_fdb.updateForfeitPrintDemDt(c_id, m_id, l_cd, Util.parseInt(seq_no), user_id)) flag1 += 1;
		 			
	subject 		= gov_nm+"님, 과태료 안내문 입니다.";
	msg 			= gov_nm+"님, 과태료 안내문 입니다.";
	
	//email = "koobuk@gmail.com";
	
	if(!email.equals("")){
		//	1. d-mail 등록-------------------------------
		DmailBean d_bean = new DmailBean();
		
		d_bean.setSubject				(subject);
		d_bean.setSql					("SSV:"+email.trim());
		d_bean.setReject_slist_idx		(0);
		d_bean.setBlock_group_idx		(0);
		d_bean.setMailfrom				("\"아마존카\"<tax300@amazoncar.co.kr>");
		d_bean.setMailto				("\""+gov_nm+"\"<"+email.trim()+">");
		d_bean.setReplyto				("\"아마존카\"<tax300@amazoncar.co.kr>");
		d_bean.setErrosto				("\"아마존카\"<tax300@amazoncar.co.kr>");
		d_bean.setHtml					(1);
		d_bean.setEncoding				(3);
		d_bean.setCharset				("euc-kr");
		d_bean.setDuration_set			(1);
		d_bean.setClick_set				(0);
		d_bean.setSite_set				(0);
		d_bean.setAtc_set				(0);
		d_bean.setGubun					("fine_bill_snr");
		d_bean.setRname					("mail");
		d_bean.setMtype       			(0);
		d_bean.setU_idx       			(1);//admin계정
		d_bean.setG_idx					(fcnt);//admin계정
		d_bean.setMsgflag     			(0);

//		d_bean.setContent				("http://fms1.amazoncar.co.kr/mailing/rent/email_fine_notice.jsp?content_seq="+content_seq+"&gov_nm="+gov_nm);
//		d_bean.setContent				("http://fms1.amazoncar.co.kr/mailing/rent/email_fine_notice.jsp?gov_nm="+URLEncoder.encode(gov_nm, "EUC-KR")+
//													 "&file_size="+file_size3+"&file_type="+file_type3+"&seq="+seq3+"&title="+URLEncoder.encode(notice_title, "EUC-KR")+
//													 "&gov_id="+gov_id);
													 
		d_bean.setContent				("http://fms1.amazoncar.co.kr/mailing/rent/email_fine_notice.jsp?gov_nm="+URLEncoder.encode(gov_nm, "EUC-KR")+
												 	"&file_size="+file_size3+"&file_type="+file_type3+"&seq="+seq3+"&title="+URLEncoder.encode(notice_title, "EUC-KR")+
												 	"&gov_id="+gov_id+"&vio_pla="+URLEncoder.encode(vio_pla, "EUC-KR")+"&vio_dt="+vio_dt+"&vio_st="+vio_st+
												 	"&vio_cont="+URLEncoder.encode(vio_cont, "EUC-KR"));
				
//		seqidx = ImEmailDb.insertDEmail2(d_bean, "4", "", "+7");
		seqidx = ImEmailDb.insertDEmail3(d_bean, "4", "", "+7", c_id, m_id, l_cd, Util.parseInt(seq_no));

		for(int i=1; i <=fcnt; i++){
			EDmailBean ed_bean = new EDmailBean();			
			idx = ImEmailDb.insertEDEmail(ed_bean, c_id, m_id, l_cd, Util.parseInt(seq_no));
		}		   
	}
%>
<script>
<%	if(seqidx > 0){%>
			alert("정상적으로 처리되었습니다.");
<%	}else{%>
			alert("에러발생!");
<%	}%>
</script>
</body>
</html>