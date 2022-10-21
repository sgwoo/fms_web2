<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<%@ page import="acar.cont.*, acar.tint.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
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
	
	String v_tint_no  = request.getParameter("v_tint_no")==null?"":request.getParameter("v_tint_no");
	String v_off_id  = request.getParameter("v_off_id")==null?"":request.getParameter("v_off_id");
	
	
	boolean flag1 = true;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
%>


<%

	String tint_no[]  	= request.getParameterValues("tint_no");
	String com_nm[]  	= request.getParameterValues("com_nm");
	String model_nm[]  	= request.getParameterValues("model_nm");
	String tint_su[]  	= request.getParameterValues("tint_su");
	String etc[]  		= request.getParameterValues("etc");
	String sup_est_dt[]  	= request.getParameterValues("sup_est_dt");
	String sup_est_h[]  	= request.getParameterValues("sup_est_h");
	String sup_dt[]  	= request.getParameterValues("sup_dt");
	String sup_h[]  	= request.getParameterValues("sup_h");
	String serial_no[]  	= request.getParameterValues("serial_no");
	
	int tint_size 		= tint_no.length;
	
	String o_sup_est_dt = "";
	String n_sup_est_dt = "";
	
	for(int i=0;i < tint_size;i++){
	
		TintBean tint 	= t_db.getCarTint(tint_no[i]);
		
		if(v_off_id.equals(tint.getOff_id())){
		

		
			tint.setCom_nm			(com_nm[i]==null?"":com_nm[i]);
			tint.setModel_nm		(model_nm[i]==null?"":model_nm[i]);

			//대량용품
			if(tint.getRent_l_cd().equals("")){						
			
				o_sup_est_dt = tint.getSup_est_dt();
				
				String r_sup_est_dt 	= sup_est_dt[i]==null?"":sup_est_dt[i];
				String r_sup_est_h 	= sup_est_h[i]==null?"":sup_est_h[i];

				tint.setSup_est_dt	(r_sup_est_dt+" "+r_sup_est_h);

				tint.setTint_su		(tint_su[i]==null? 0:AddUtil.parseDigit(tint_su[i]));		
				tint.setEtc		(etc[i]==null?"":etc[i]);			
				
				n_sup_est_dt = tint.getSup_est_dt();
				
				if(tint.getOff_nm().equals("젤존코리아")){
					tint.setTint_amt		(request.getParameter("tint_amt")==null? 0:AddUtil.parseDigit(request.getParameter("tint_amt")));		
					tint.setR_tint_amt		(tint.getTint_amt());	
				}
			
			//계약별용품
			}else{
				o_sup_est_dt = tint.getSup_dt();
				
				String r_sup_dt 	= sup_dt[i]==null?"":sup_dt[i];
				String r_sup_h 		= sup_h[i]==null?"":sup_h[i];

				tint.setSup_dt		(r_sup_dt+" "+r_sup_h);
				
				tint.setSerial_no	(serial_no[i]==null?"":serial_no[i]);	
				
				if(tint.getTint_st().equals("3")){
					tint.setModel_id	(request.getParameter("model_id")==null?"":request.getParameter("model_id"));
				}
				
				if(tint.getTint_amt() == 0 && tint.getTint_st().equals("3") && tint.getTint_yn().equals("Y") && !tint.getModel_id().equals("")){
					//if(AddUtil.parseInt(r_sup_dt) < 20160201)	tint.setTint_amt(104545);
					//else						                          tint.setTint_amt(92727);
					tint.setTint_amt(92727);
					if(AddUtil.parseInt(r_sup_dt) > 20161031 && tint.getOff_id().equals("002849"))	tint.setTint_amt(87727);
				}

				//20161025 전면썬팅 50000 디폴트 셋팅
				if(tint.getTint_amt() == 0 && tint.getTint_st().equals("2")){
					tint.setTint_amt(50000);
				}
				
				n_sup_est_dt = tint.getSup_dt();
			
			}
		
			//=====[tint] update=====
			flag1 = t_db.updateCarTint(tint);	
			
			
			//다옴방일때 작업요청일 변경시 문자발송
			if(!tint.getRent_l_cd().equals("") && tint.getOff_id().equals("002849") && tint.getTint_yn().equals("Y") && !AddUtil.replace(n_sup_est_dt,"-","").equals(AddUtil.replace(o_sup_est_dt,"-",""))){
				
				UsersBean target_bean2 	= umd.getUsersBean("000103");						
		
				String sms_content = "[작업요청일 변경안내] 계출번호:"+request.getParameter("rpt_no")+", 상호:"+request.getParameter("firm_nm")+", 차명:"+request.getParameter("car_nm")+", 썬팅 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
				
				if(tint.getTint_st().equals("3")){
					sms_content = "[작업요청일 변경안내] 계출번호:"+request.getParameter("rpt_no")+", 상호:"+request.getParameter("firm_nm")+", 차명:"+request.getParameter("car_nm")+", 블랙박스 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
				}
				if(tint.getTint_st().equals("4")){
					sms_content = "[작업요청일 변경안내] 계출번호:"+request.getParameter("rpt_no")+", 상호:"+request.getParameter("firm_nm")+", 차명:"+request.getParameter("car_nm")+", 내비게이션 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
				}
				if(tint.getTint_st().equals("5")){
					sms_content = "[작업요청일 변경안내] 계출번호:"+request.getParameter("rpt_no")+", 상호:"+request.getParameter("firm_nm")+", 차명:"+request.getParameter("car_nm")+", "+tint.getCom_nm()+" 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
				}

					
				int i_msglen = AddUtil.lengthb(sms_content);
		
				String msg_type = "0";
		
				//80이상이면 장문자
				if(i_msglen>80) msg_type = "5";
					
				String send_phone = sender_bean.getUser_m_tel();
			
				if(!sender_bean.getHot_tel().equals("")){
					send_phone = sender_bean.getHot_tel();
				}
							
				IssueDb.insertsendMail_V5_H(send_phone, sender_bean.getUser_nm(), target_bean2.getUser_m_tel(), target_bean2.getUser_nm(), "", "", msg_type, "[작업요청일 변경안내]", sms_content, "", "", ck_acar_id, "tint_est");				
			
			}
			
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
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'tint_reg_step2.jsp';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>