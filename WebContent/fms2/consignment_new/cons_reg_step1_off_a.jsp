<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.car_sche.*, acar.user_mng.*, acar.cont.*, acar.car_sche.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
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
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag12 = true;
	int result = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
%>

<%
	String cons_no	 	= "";
	
	int    cons_su	 	= request.getParameter("cons_su")==null?1:AddUtil.parseInt(request.getParameter("cons_su"));
	String cons_st	 	= request.getParameter("cons_st")==null?"1":request.getParameter("cons_st");
	String off_id	 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String off_nm	 	= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	String req_id	 	= request.getParameter("req_id")==null?"":request.getParameter("req_id");
	String cmp_app	 	= request.getParameter("cmp_app")==null?"":request.getParameter("cmp_app");
	String cons_cau	 	= request.getParameter("cons_cau")==null?"":request.getParameter("cons_cau");
	String cons_cau_etc	 	= request.getParameter("cons_cau_etc")==null?"":request.getParameter("cons_cau_etc");		
	String cost_st	 	= request.getParameter("cost_st")==null?"":request.getParameter("cost_st");
	String pay_st	 	= request.getParameter("pay_st")==null?"":request.getParameter("pay_st");
	
	String from_st	 	= request.getParameter("from_st")==null?"":request.getParameter("from_st");
	String from_place	 	= request.getParameter("from_place")==null?"":request.getParameter("from_place");
	String from_comp	 	= request.getParameter("from_comp")==null?"":request.getParameter("from_comp");
	String from_title	 	= request.getParameter("from_title")==null?"":request.getParameter("from_title");
	String from_man	 	= request.getParameter("from_man")==null?"":request.getParameter("from_man");
	String from_tel	 	= request.getParameter("from_tel")==null?"":request.getParameter("from_tel");
	String from_m_tel	 	= request.getParameter("from_m_tel")==null?"":request.getParameter("from_m_tel");	
	String from_req_dt	 	= request.getParameter("from_req_dt")==null?"":request.getParameter("from_req_dt");
	String from_req_h	 	= request.getParameter("from_req_h")==null?"":request.getParameter("from_req_h");
	String from_req_s	 	= request.getParameter("from_req_s")==null?"":request.getParameter("from_req_s");
	String to_st	 	= request.getParameter("to_st")==null?"":request.getParameter("to_st");
	String to_place	 	= request.getParameter("to_place")==null?"":request.getParameter("to_place");
	String to_comp	 	= request.getParameter("to_comp")==null?"":request.getParameter("to_comp");
	String to_title	 	= request.getParameter("to_title")==null?"":request.getParameter("to_title");
	String to_man	 	= request.getParameter("to_man")==null?"":request.getParameter("to_man");
	String to_tel	 	= request.getParameter("to_tel")==null?"":request.getParameter("to_tel");
	String to_m_tel	 	= request.getParameter("to_m_tel")==null?"":request.getParameter("to_m_tel");	
	String to_req_dt	 	= request.getParameter("to_req_dt")==null?"":request.getParameter("to_req_dt");
	String to_req_h	 	= request.getParameter("to_req_h")==null?"":request.getParameter("to_req_h");
	String to_req_s	 	= request.getParameter("to_req_s")==null?"":request.getParameter("to_req_s");
		
	String client_id	 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");	
	int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
	
	String sms_msg	 	= request.getParameter("sms_msg")==null?"":request.getParameter("sms_msg");
	String sms_msg2	 	= request.getParameter("sms_msg2")==null?"":request.getParameter("sms_msg2");
				
	
	String target_id 	= "";
	
	String today	 	= AddUtil.getDate();
	int    after_cnt	= 0;
	
	String reg_code  ="";
	
	String car_mng_id	[]		= request.getParameterValues("car_mng_id");
	String rent_mng_id	[] 		= request.getParameterValues("rent_mng_id");
	String rent_l_cd	[] 		= request.getParameterValues("rent_l_cd");
	String car_no		[] 		= request.getParameterValues("car_no");
	String car_nm		[] 		= request.getParameterValues("car_nm");
		
	String  t_cmp_app = "";  //전국탁송구간
 	int  t_cmp_amt = 0;    //전국탁송구간요금
	
	//1. 탁송의뢰 등록----------------------------------------------------------------------------------------	
		
	for(int i=0; i<size; i++){

		ConsignmentBean cons = new ConsignmentBean();
			
		reg_code  = Long.toString(System.currentTimeMillis());
		 		 		
		cons.setCons_no			("");
		cons.setSeq				(1);
		cons.setCons_su			(cons_su);
		cons.setReg_code		(reg_code);
		cons.setOff_id			(off_id);
		cons.setOff_nm			(off_nm);
		cons.setCons_st			(cons_st);
		cons.setCmp_app			(cmp_app);
		cons.setReq_id			(req_id);
		cons.setReg_id			(user_id);
		cons.setReg_dt			(AddUtil.getDate());
		cons.setCar_mng_id		(car_mng_id   	[i] ==null?"": car_mng_id   	[i]);
		cons.setRent_mng_id		(rent_mng_id  	[i] ==null?"": rent_mng_id  	[i]);
		cons.setRent_l_cd		(rent_l_cd    	[i] ==null?"": rent_l_cd    	[i]);
		cons.setClient_id		(client_id);
		cons.setCar_no			(car_no       	[i] ==null?"": car_no       	[i]);
		System.out.println( car_no       	[i] );
		cons.setCar_nm			(car_nm       	[i] ==null?"": car_nm       	[i]);
		cons.setCons_cau		(cons_cau);
		cons.setCons_cau_etc	(cons_cau_etc);
		cons.setCost_st			(cost_st);
		cons.setPay_st			(pay_st );
		cons.setFrom_st      	(from_st);
		cons.setFrom_place   	(from_place);
		cons.setFrom_comp    	(from_comp);
		cons.setFrom_title   	(from_title );
		cons.setFrom_man     	(from_man );
		cons.setFrom_tel	  	(from_tel	);
		cons.setFrom_m_tel   	(from_m_tel);
		cons.setFrom_req_dt  	(from_req_dt+from_req_h+from_req_s);
		//cons.setFrom_est_dt  	(from_req_dt+from_req_h+from_req_s);
		cons.setTo_st		  	(to_st);
		cons.setTo_place     	(to_place);
		cons.setTo_comp      	(to_comp);
		cons.setTo_title     	(to_title);
		cons.setTo_man       	(to_man);
		cons.setTo_tel	      	(to_tel);
		cons.setTo_m_tel     	(to_m_tel);
		cons.setTo_req_dt    	(to_req_dt+to_req_h+to_req_s);
		//cons.setTo_est_dt    	(to_req_dt+to_req_h+to_req_s);
	
		//=====[consignment] insert=====
		cons_no = cs_db.insertConsignment(cons);

		if(cons_no.equals("")){
			result++;
		}	
					
		if(result>0){
			//부분실패시 모두 삭제
			flag3 = cs_db.deleteConsignments(reg_code);
			
		}else{
			
			UsersBean sender_bean 	= umd.getUsersBean(req_id);
			
			//2. 문서처리전 등록-------------------------------------------------------------------------------------------
			
			String sub 		= "탁송의뢰";
			String cont 	= sms_msg2;
			
			if(off_id.equals("000620")) target_id = "000047";//명진공업사
			if(off_id.equals("002371")) target_id = "000094";//코리아탁송
			if(off_id.equals("002740")) target_id = "000095";//전국탁송
			if(off_id.equals("004107")) target_id = "000127";//코리아탁송부산
			if(off_id.equals("004171")||off_id.equals("007547")) target_id = "000139";//하이카콤대전, 하이카콤부산
			if(off_id.equals("007751")) target_id = "000187";//(주)삼진특수
			if(off_id.equals("009026")) target_id = "000222";//(주)영원물류
			if(off_id.equals("011372")) target_id = "000308";//상원물류(주)
			if(off_id.equals("009217")) target_id = "000223";//(주)아마존탁송
			if(off_id.equals("010255")) target_id = "000263";//스마일TS
			if(off_id.equals("011790")) target_id = "000328";//퍼스트드라이브
			
		//	if(off_id.equals("010919")||off_id.equals("010920") ||off_id.equals("010921") )   target_id = "000196";//일등전국탁송물류		 
			if(off_id.equals("010919")||off_id.equals("010920") ||off_id.equals("010921") ||off_id.equals("008411")||off_id.equals("008468") ||off_id.equals("008516") )   target_id = "000196";//일등전국탁송물류
					
			DocSettleBean doc = new DocSettleBean();
			doc.setDoc_st("2");//탁송의뢰
			doc.setDoc_id(cons_no);
			doc.setSub(sub);
			doc.setCont(cont);
			doc.setEtc("");
			doc.setUser_nm1("의뢰");
			doc.setUser_nm2("수신");
			doc.setUser_nm3("정산");
			doc.setUser_id1(req_id);
			doc.setUser_id2(target_id);
			doc.setUser_id3(target_id);
			if(!off_id.equals("003158")){
				doc.setUser_nm4("청구");
				doc.setUser_nm5("확인");
				doc.setUser_nm6("팀장");
				doc.setUser_id4(target_id);
				doc.setUser_id5(req_id);
			}
			doc.setDoc_bit("1");//수신단계
			doc.setDoc_step("1");//기안
						
			//=====[doc_settle] insert=====
			flag1 = d_db.insertDocSettle(doc);
						
			if(off_id.equals("003158") && req_id.equals(target_id)){
				DocSettleBean doc2 = d_db.getDocSettleCommi("2", cons_no);
				flag2 = d_db.updateDocSettle(doc2.getDoc_no(), user_id, "2", "2");
				out.println("문서처리전 결재<br>");
			}
				
		}//기안 
	}
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <%if(off_id.equals("003158") && req_id.equals(target_id))%>  <input type="hidden" name="cons_no" 			value="<%=cons_no%>">
</form>
<script language='javascript'>
	var flag = 0;	
<%		if(result>0){	%>	alert('탁송의뢰 등록 에러입니다.\n\n확인하십시오');		flag = 1;<%		}	%>		
<%		if(!flag1){		%>	alert('문서품의서 등록 에러입니다.\n\n확인하십시오');	flag = 1;<%		}	%>		
<%		if(!flag2){		%>	alert('쿨메신저 등록 에러입니다.\n\n확인하십시오');		flag = 1;<%		}	%>		

	if(flag == 0){
		alert('등록되었습니다.');
		parent.parent.location.reload();		
		
	}else{
		alert('등록되지 않았습니다. 확인바랍니다.');
	}
</script>
</body>
</html>

