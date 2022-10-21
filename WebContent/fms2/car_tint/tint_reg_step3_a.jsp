<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<%@ page import="acar.cont.*, acar.tint.*, acar.doc_settle.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
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
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	String v_tint_no = request.getParameter("v_tint_no")==null?"":request.getParameter("v_tint_no");
	String v_off_id	 = request.getParameter("v_off_id")==null?"":request.getParameter("v_off_id");	
	String v_doc_no  = request.getParameter("v_doc_no")==null?"":request.getParameter("v_doc_no");
	
	
	
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	
%>


<%

	String tint_no[]  	= request.getParameterValues("tint_no");
	String com_nm[]  	= request.getParameterValues("com_nm");
	String model_nm[]  	= request.getParameterValues("model_nm");
	String tint_su[]  	= request.getParameterValues("tint_su");
	String tint_amt[]  	= request.getParameterValues("tint_amt");
	String etc[]  		= request.getParameterValues("etc");
	String sup_est_dt[]  	= request.getParameterValues("sup_est_dt");
	String sup_est_h[]  	= request.getParameterValues("sup_est_h");
	String sup_dt[]  	= request.getParameterValues("sup_dt");
	String sup_h[]  	= request.getParameterValues("sup_h");
	String serial_no[]  	= request.getParameterValues("serial_no");
	
	int tint_size 		= tint_no.length;
	
	String off_nm = "";
	

	
	

	
	for(int i=0;i < tint_size;i++){
	
		TintBean tint 	= t_db.getCarTint(tint_no[i]);
		
		
		off_nm = tint.getOff_nm();
		
		
		
		if(v_off_id.equals(tint.getOff_id())){

			String r_sup_dt 	= sup_dt[i]==null?"":sup_dt[i];
			String r_sup_h 		= sup_h[i]==null?"":sup_h[i];

			tint.setSup_dt		(r_sup_dt+" "+r_sup_h);
		
			tint.setCom_nm			(com_nm[i]==null?"":com_nm[i]);
			tint.setModel_nm		(model_nm[i]==null?"":model_nm[i]);
			tint.setTint_amt		(tint_amt[i]==null? 0:AddUtil.parseDigit(tint_amt[i]));
			tint.setR_tint_amt		(tint_amt[i]==null? 0:AddUtil.parseDigit(tint_amt[i]));
			
			if(tint.getTint_st().equals("3")){
				tint.setModel_id	(request.getParameter("model_id")==null?"":request.getParameter("model_id"));
			}
			

			//대량용품
			if(tint.getRent_l_cd().equals("")){						
				tint.setTint_su		(tint_su[i]==null? 0:AddUtil.parseDigit(tint_su[i]));
				tint.setEtc		(etc[i]==null?"":etc[i]);			
			
			//계약별용품
			}else{				
				tint.setSerial_no	(serial_no[i]==null?"":serial_no[i]);						
			}
			
			//이동형충전기 정산시 청구까지 처리
			if(v_off_id.equals("011281")){
				tint.setConf_dt		(r_sup_dt);
			}
		
			//=====[tint] update=====
			flag1 = t_db.updateCarTint(tint);
			
			
			//정산결재시 블랙박스 다옴방이외에서 설치하는 경우 다옴방 기계값, 공임비 분리해야 한다.			
				if(!tint.getRent_l_cd().equals("") && tint.getTint_st().equals("3") && tint.getTint_yn().equals("Y") && !tint.getModel_id().equals("")){	
					
				  if(AddUtil.parseInt(tint.getReg_dt().substring(0,8)) >= 20161101){
						//기존 블랙박스 정산에서 기계값 제외
						if(tint.getTint_amt() == 104545) 	tint.setR_tint_amt(tint.getTint_amt()-84545);
						if(tint.getTint_amt() == 92727) 	tint.setR_tint_amt(tint.getTint_amt()-72727);
						if(tint.getTint_amt() == 87727) 	tint.setR_tint_amt(tint.getTint_amt()-72727);
						if(tint.getTint_amt() == 20000){
							tint.setTint_amt	(tint.getTint_amt()+72727);
							tint.setR_tint_amt(tint.getTint_amt()-72727);
						}
						if(tint.getTint_amt() == 15000){
							tint.setTint_amt	(tint.getTint_amt()+72727);
							tint.setR_tint_amt(tint.getTint_amt()-72727);
						}						
				 	}else{
				 		if(!tint.getOff_id().equals("002849")){
							//기존 블랙박스 정산에서 기계값 제외
							if(tint.getTint_amt() == 104545) 	tint.setR_tint_amt(tint.getTint_amt()-84545);
							if(tint.getTint_amt() == 92727) 	tint.setR_tint_amt(tint.getTint_amt()-72727);
							if(tint.getTint_amt() == 87727) 	tint.setR_tint_amt(tint.getTint_amt()-72727);
							if(tint.getTint_amt() == 20000){
								tint.setTint_amt	(tint.getTint_amt()+72727);
								tint.setR_tint_amt(tint.getTint_amt()-72727);
							}
							if(tint.getTint_amt() == 15000){
								tint.setTint_amt	(tint.getTint_amt()+72727);
								tint.setR_tint_amt(tint.getTint_amt()-72727);
							}
						}
				 	}
				
					
					//=====[tint] update=====
					flag1 = t_db.updateCarTint(tint);
				}
			
		}
				
	}
	

	//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
	
		
	//정산 결재
	if(doc_bit.equals("3")){
	
		String doc_step = "2";
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(v_doc_no, user_id, doc_bit, doc_step);
		
		
		//이동형충전기 정산시 청구까지 처리
		if(v_off_id.equals("011281")){
			//=====[doc_settle] update=====
			flag2 = d_db.updateDocSettle(v_doc_no, user_id, "4", doc_step);
			//=====[doc_settle] update=====
			flag2 = d_db.updateDocSettle(v_doc_no, user_id, "5", doc_step);
		}
		

	}	
	
	
		
	%>
<script language='javascript'>
<%if(!flag1){%>alert('용품 수정 에러입니다.\n\n확인하십시오');<%}%>		
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
  <input type='hidden' name='tint_no' 	value='<%=v_tint_no%>'>    
  <input type='hidden' name='off_id' 	value='<%=v_off_id%>'>    
  <input type='hidden' name='doc_no' 	value='<%=v_doc_no%>'>    
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'tint_reg_step3.jsp';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>