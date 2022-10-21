<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.admin.*,  acar.im_email.*, tax.*"%>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
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
	
	int flag1 = 0;

	int result = 0;
	
	//과태료정보
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");		
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String res_firm = request.getParameter("res_firm")==null?"":request.getParameter("res_firm");
	
	String dem_dt = request.getParameter("dem_dt")==null?"":request.getParameter("dem_dt");
	String e_dem_dt = request.getParameter("e_dem_dt")==null?"":request.getParameter("e_dem_dt");
	

	Hashtable base = ad_db.getContEmail(m_id, l_cd);	
	
	if(email.equals("")){
		email = String.valueOf(base.get("EMAIL"));
	}
	
	/*
	System.out.println("c_id: "+c_id);
	System.out.println("m_id: "+m_id);
	System.out.println("l_cd: "+l_cd);
	System.out.println("email: "+email);
	*/
	
	/*
	if(c_id.equals("011174")&&m_id.equals("014488")&&l_cd.equals("S112HHGR00048")){
		email = "nest9090@hanmail.net";
	}
	*/
	
	if(seq_no.equals("")){//최초 과태료 납부자변경 등록하고 메일 보낼때 마지막 번호 가져오기.
		Hashtable ht = a_fdb.getForfeitSeq_no(c_id, m_id, l_cd);
		seq_no = String.valueOf(ht.get("SEQ_NO"));
	}	
//	System.out.println("seq_no: "+seq_no);
	String subject 		= "";
	String msg 			= "";
	String mms 			= "";
	String sendname 	= "(주)아마존카";
	String sendphone 	= "02-392-4242";
	int seqidx			= 0;	
	
	String gov_nm = "";
	gov_nm = firm_nm;
	
	if (!res_firm.equals("") ) {
		gov_nm = res_firm;
	}	
	
	if(gov_nm.equals("주식회사 폴리메탈")){//2012.10.26일 고객의 요청으로 인하여 메일을 발송하지 않도록 함.
		email = "koobuk@gmail.com";
	//}else{
	//	email = String.valueOf(base.get("EMAIL"));
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
	
	//일단 test	
	//System.out.println("email: "+email);
	//email = "gillsun@naver.com";	
		 			
	subject 		= gov_nm+"님, 고객위반 과태료 납부자변경(재발행) 내역안내 입니다.";
	msg 			= gov_nm+"님, 고객위반 과태료 납부자변경(재발행) 내역안내 입니다.";
		
	if(!email.equals("") && !email.equals("null")){
			//	1. d-mail 등록-------------------------------
			DmailBean d_bean = new DmailBean();
			
			d_bean.setSubject			(subject);
			d_bean.setSql				("SSV:"+email.trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"아마존카\"<tax300@amazoncar.co.kr>");
			d_bean.setMailto			("\""+gov_nm+"\"<"+email.trim()+">");
			d_bean.setReplyto			("\"아마존카\"<tax300@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<tax300@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(3);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(fcnt);//첨부파일 갯수
			d_bean.setGubun				("fine_bill_nbcr");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin계정
			d_bean.setG_idx				(fcnt);//admin계정
			d_bean.setMsgflag     		(0);
		
			d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/rent/email_fine_bill_nbc.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&dem_dt="+dem_dt+"&e_dem_dt="+e_dem_dt+"&seq_no="+Util.parseInt(seq_no));
	
		   	
			seqidx = ImEmailDb.insertDEmail3(d_bean, "4", "", "+7", c_id, m_id, l_cd, Util.parseInt(seq_no));

			for(int i=1; i <=fcnt; i++){

			EDmailBean ed_bean = new EDmailBean();

			if(i == 1){ 
			if(file_name1.equals("")){
				file_name1 = "-";
			}
			ed_bean.setFileinfo(file_name1);
			ed_bean.setContent("https://fms3.amazoncar.co.kr/data/fine/"+file_name1);
			}
			if(i == 2){
				if(file_name2.equals("")){
					file_name2 = "-";
				}
				ed_bean.setFileinfo(file_name2);
				ed_bean.setContent("https://fms3.amazoncar.co.kr/data/fine/"+file_name2);
			}		
			
			
			
			idx = ImEmailDb.insertEDEmail(ed_bean, c_id, m_id, l_cd, Util.parseInt(seq_no));

		} 

		//    System.out.println("http://fms2.amazoncar.co.kr/mailing/rent/email_fine_bill3.jsp?m_id="+m_id+"&l_cd="+l_cd+"&dem_dt="+dem_dt+"&e_dem_dt="+e_dem_dt+"&seq_no="+Util.parseInt(seq_no));
		   
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