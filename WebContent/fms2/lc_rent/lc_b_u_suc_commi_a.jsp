<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.ext.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
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
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	String fee_size 	= request.getParameter("fee_size")		==null?"":request.getParameter("fee_size");
	String now_stat	 	= request.getParameter("now_stat")		==null?"":request.getParameter("now_stat");
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag9 = true;
	boolean flag12 = true;
	
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
%>





<%
	if(idx.equals("suc_commi")){
	
		//계약기타정보-----------------------------------------------------------------------------------------------
		
		cont_etc.setRent_suc_commi	(request.getParameter("rent_suc_commi")==null? 0:AddUtil.parseDigit(request.getParameter("rent_suc_commi")));
		cont_etc.setRent_suc_dt		(request.getParameter("rent_suc_dt")==null?"":request.getParameter("rent_suc_dt"));
		cont_etc.setRent_suc_grt_yn	(request.getParameter("rent_suc_grt_yn")==null?"":request.getParameter("rent_suc_grt_yn"));		
		cont_etc.setRent_suc_commi_pay_st(request.getParameter("rent_suc_commi_pay_st")	==null?"":request.getParameter("rent_suc_commi_pay_st"));
		
		if(cont_etc.getRent_suc_commi()>0 && cont_etc.getRent_suc_commi_pay_st().equals("")){
			cont_etc.setRent_suc_commi_pay_st("2"); 
		}
		
		cont_etc.setGrt_suc_o_amt	(request.getParameter("suc_grt_suc_o_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_grt_suc_o_amt")));
		cont_etc.setGrt_suc_r_amt	(request.getParameter("suc_grt_suc_r_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_grt_suc_r_amt")));
		cont_etc.setRent_suc_fee_tm	(request.getParameter("rent_suc_fee_tm")==null?"":request.getParameter("rent_suc_fee_tm"));
		cont_etc.setRent_suc_fee_tm_b_dt(request.getParameter("rent_suc_fee_tm_b_dt")==null?"":request.getParameter("rent_suc_fee_tm_b_dt"));
		
		cont_etc.setRent_suc_exem_cau	(request.getParameter("rent_suc_exem_cau")	==null?"":request.getParameter("rent_suc_exem_cau"));
		cont_etc.setRent_suc_exem_id	(request.getParameter("rent_suc_exem_id")	==null?"":request.getParameter("rent_suc_exem_id"));
	
		if(cont_etc.getRent_suc_exem_cau().equals("4")){
			cont_etc.setRent_suc_exem_cau	(request.getParameter("rent_suc_exem_cau_sub")	==null?"":request.getParameter("rent_suc_exem_cau_sub"));
		}		
		
		cont_etc.setRent_suc_route	(request.getParameter("rent_suc_route")	==null?"":request.getParameter("rent_suc_route"));
		cont_etc.setRent_suc_dist	(request.getParameter("rent_suc_dist")==null? 0:AddUtil.parseDigit(request.getParameter("rent_suc_dist")));
		
		cont_etc.setRent_suc_pp_yn	(request.getParameter("rent_suc_pp_yn")==null?"":request.getParameter("rent_suc_pp_yn"));
		cont_etc.setPp_suc_o_amt	(request.getParameter("suc_pp_suc_o_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_pp_suc_o_amt")));
		cont_etc.setPp_suc_r_amt	(request.getParameter("suc_pp_suc_r_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_pp_suc_r_amt")));
		cont_etc.setRent_suc_ifee_yn(request.getParameter("rent_suc_ifee_yn")==null?"":request.getParameter("rent_suc_ifee_yn"));
		cont_etc.setIfee_suc_o_amt	(request.getParameter("suc_ifee_suc_o_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_ifee_suc_o_amt")));
		cont_etc.setIfee_suc_r_amt	(request.getParameter("suc_ifee_suc_r_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_ifee_suc_r_amt")));
		cont_etc.setN_mon			(request.getParameter("n_mon")==null?"":request.getParameter("n_mon"));
		cont_etc.setN_day			(request.getParameter("n_day")==null?"":request.getParameter("n_day"));		
		
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag2 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag2 = a_db.updateContEtc(cont_etc);
		}
		
		
		if(cont_etc.getRent_suc_commi()>0){
			
			int suc_commi_s_amt = request.getParameter("suc_commi_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_commi_s_amt"));
			int suc_commi_v_amt = request.getParameter("suc_commi_v_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_commi_v_amt"));
			
			
			//승계수수료
			ExtScdBean suc = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//기존 등록 여부 조회
			
						

			if(suc == null || suc.getRent_l_cd().equals("")){
				
			}else{				
			
				//승계수수료 동일하고 공급가 금액 미세조정시
				if(suc.getExt_s_amt()+suc.getExt_v_amt() > suc_commi_s_amt+suc_commi_v_amt || suc.getExt_s_amt()+suc.getExt_v_amt() < suc_commi_s_amt+suc_commi_v_amt){
					if(cont_etc.getRent_suc_commi() == suc.getExt_s_amt()+suc.getExt_v_amt()){
						suc.setExt_s_amt	(suc_commi_s_amt);
						suc.setExt_v_amt	(suc_commi_v_amt);
						//=====[scd_pre] update=====
						flag6 = ae_db.i_updateGrt(suc);
					}else{
						if(!suc.getExt_pay_dt().equals("")){
							if(suc_commi_s_amt>0){
								suc.setExt_s_amt	(suc_commi_s_amt);
								suc.setExt_v_amt	(suc_commi_v_amt);
							}else{
								suc.setExt_s_amt	(AddUtil.parseInt(String.valueOf(AddUtil.parseFloat(String.valueOf(cont_etc.getRent_suc_commi()))/1.1)));
								suc.setExt_v_amt	(cont_etc.getRent_suc_commi()-suc.getExt_s_amt());
							}
							//=====[scd_pre] update=====
							flag6 = ae_db.updateGrt(suc);
						}else{
							if(suc.getExt_pay_dt().equals("") && suc.getExt_v_amt()>0){
								if(suc_commi_s_amt>0){
									suc.setExt_s_amt	(suc_commi_s_amt);
									suc.setExt_v_amt	(suc_commi_v_amt);
								}else{
									suc.setExt_s_amt	(AddUtil.parseInt(String.valueOf(AddUtil.parseFloat(String.valueOf(cont_etc.getRent_suc_commi()))/1.1)));
									suc.setExt_v_amt	(cont_etc.getRent_suc_commi()-suc.getExt_s_amt());
								}
								//=====[scd_pre] update=====
								flag6 = ae_db.updateGrt(suc);
							}else if(suc.getExt_pay_dt().equals("") && suc.getExt_v_amt()==0 && suc_commi_v_amt > 0){
									suc.setExt_s_amt	(suc_commi_s_amt);
									suc.setExt_v_amt	(suc_commi_v_amt);
									//=====[scd_pre] update=====
									flag6 = ae_db.i_updateGrt(suc); //잔액체크없이 수정
							}else if(suc.getExt_pay_dt().equals("") && suc.getExt_v_amt()==0 && suc_commi_v_amt == 0){
									suc.setExt_s_amt	(suc_commi_s_amt);
									suc.setExt_v_amt	(suc_commi_v_amt);
									//=====[scd_pre] update=====
									flag6 = ae_db.i_updateGrt(suc); //잔액체크없이 수정
							}else{
								if(suc.getExt_s_amt()+suc.getExt_v_amt()==0){
									suc.setExt_s_amt	(suc_commi_s_amt);
									suc.setExt_v_amt	(suc_commi_v_amt);
									//=====[scd_pre] update=====
									flag6 = ae_db.i_updateGrt(suc); //잔액체크없이 수정
								}
							}
						}
					}
				}else{
					if(suc.getExt_pay_dt().equals("")){
						if(suc.getExt_s_amt() > suc_commi_s_amt || suc.getExt_s_amt() < suc_commi_s_amt || suc.getExt_v_amt() > suc_commi_v_amt || suc.getExt_v_amt() < suc_commi_v_amt){
							suc.setExt_s_amt	(suc_commi_s_amt);
							suc.setExt_v_amt	(suc_commi_v_amt);
							//=====[scd_pre] update=====
							flag6 = ae_db.i_updateGrt(suc); //잔액체크없이 수정					
						}
					}
				}
			}
		}
		if(cont_etc.getRent_suc_commi()==0){
			//승계수수료
			ExtScdBean suc = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//기존 등록 여부 조회
			
			if(suc == null || suc.getRent_l_cd().equals("")){
				
			}else{	
				if(suc.getExt_pay_dt().equals("")){
					suc.setExt_s_amt	(0);
					suc.setExt_v_amt	(0);
					//=====[scd_pre] update=====
					flag6 = ae_db.i_updateGrt(suc); //잔액체크없이 수정			
				}
			}
		}
		%>
<script language='javascript'>
</script>
<%	}%>





<%
	if(idx.equals("make_suc_schedule")){
	
		
		String suc_tax_req 	= request.getParameter("suc_tax_req")		==null?"N":request.getParameter("suc_tax_req");
		String suc_commi_est_dt	= request.getParameter("suc_commi_est_dt")	==null?"":request.getParameter("suc_commi_est_dt");
		int    suc_commi_s_amt	= request.getParameter("suc_commi_s_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("suc_commi_s_amt"));
		int    suc_commi_v_amt	= request.getParameter("suc_commi_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("suc_commi_v_amt"));
		
		
		ExtScdBean suc = new ExtScdBean();
		suc.setRent_mng_id	(rent_mng_id);
		suc.setRent_l_cd	(rent_l_cd);
		suc.setRent_st		("1");
		suc.setRent_seq		("1");
		suc.setExt_id		("0");
		suc.setExt_st		("5");
		suc.setExt_tm		("1");
		suc.setExt_s_amt	(suc_commi_s_amt);
		suc.setExt_v_amt	(suc_commi_v_amt);
		suc.setExt_est_dt	(suc_commi_est_dt);		
		suc.setUpdate_id	(user_id);
		
		flag1 = ae_db.insertGrt(suc);
		
		
		//원계약자 승계수수료 부담 - 승계계약자 스케줄 확인후 삭제
		if(cont_etc.getRent_suc_commi_pay_st().equals("2")){
		
			//승계수수료
			ExtScdBean suc2 = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//기존 등록 여부 조회
			
			if(suc2.getExt_pay_dt().equals("")){
				flag1 = ae_db.deleteGrt(suc2);
			}
			
		}
		//승계계약자 승계수수료 부담 - 원계약자 스케줄 확인후 삭제
		if(cont_etc.getRent_suc_commi_pay_st().equals("1") && cont_etc.getRent_suc_commi() != (suc.getExt_s_amt()+suc.getExt_v_amt()) ){

			//승계수수료
			ExtScdBean suc2 = ae_db.getAGrtScd(rent_mng_id, cont_etc.getRent_suc_l_cd(), "1", "5", "1");//기존 등록 여부 조회
		
			if(suc2.getExt_pay_dt().equals("")){
				flag1 = ae_db.deleteGrt(suc2);
			}
		}
		
		cont_etc.setRent_suc_commi	(suc_commi_s_amt+suc_commi_v_amt);
		//=====[cont_etc] update=====
		flag2 = a_db.updateContEtc(cont_etc);

		%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('승계수수료 스케줄 생성 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>



<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>      
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>  
  <input type='hidden' name='rent_st'	 		value=''>   
  <input type='hidden' name="now_stat"			value="<%=now_stat%>">              
</form>
<script language='javascript'>

	var fm = document.form1;
		
	fm.action = 'lc_b_u_suc_commi.jsp';	
	fm.target = 'UPDATE_SUC_COMMI';
	fm.submit();

</script>
</body>
</html>