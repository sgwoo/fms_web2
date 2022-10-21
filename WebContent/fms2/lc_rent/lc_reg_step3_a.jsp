<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
//	if(1==1)return;
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String old_rent_mng_id 		= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 		= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	String seq		 	= request.getParameter("fin_seq")==null?"":request.getParameter("fin_seq");
	String client_id 		= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;


	//1. 계약기본정보-----------------------------------------------------------------------------------------------
	
	//cont
	String dec_gr 	= request.getParameter("dec_gr")==null?"":request.getParameter("dec_gr");
	
	// ContBase insert 
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	base.setSpr_kd		(dec_gr);
	base.setReg_step	("3");
	
	//=====[cont] insert=====
	flag1 = a_db.updateContBaseNew(base);


	//2. 약식재무제표테이블 [client_fin] insert/update-------------------------------------------------
	
	String client_st 	= request.getParameter("client_st")==null?"":request.getParameter("client_st");
	
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	client_st = client.getClient_st();

	
	ClientFinBean c_fin = new ClientFinBean();
	
	if(!client_st.equals("2")){
	
				
		
		if(!base.getClient_id().equals("000228")){
			//고객재무제표-최근등록건
			Vector fin_vt = al_db.getClientFinList(base.getClient_id());
			int fin_vt_size = fin_vt.size();
			for(int i = 0 ; i < fin_vt_size ; i++){
				ClientFinBean fin = (ClientFinBean)fin_vt.elementAt(i);			
				if((i+1) == fin_vt_size){
					c_fin = fin;
				}
			}	
		}
		
		
		String c_kisu 	= request.getParameter("c_kisu")==null?"":request.getParameter("c_kisu");	//당기-기수
		
		
		//newFMS 재무제표
		c_fin.setClient_id	(base.getClient_id());
		c_fin.setC_kisu		(request.getParameter("c_kisu")==null?"":request.getParameter("c_kisu"));
		c_fin.setC_ba_year 	(request.getParameter("c_ba_year")==null?"":AddUtil.ChangeString(request.getParameter("c_ba_year")));
		c_fin.setC_asset_tot	(request.getParameter("c_asset_tot").equals("")?0:AddUtil.parseDigit2(request.getParameter("c_asset_tot")));
		c_fin.setC_cap		(request.getParameter("c_cap").equals("")?0:AddUtil.parseDigit2(request.getParameter("c_cap")));
		c_fin.setC_cap_tot	(request.getParameter("c_cap_tot").equals("")?0:AddUtil.parseDigit2(request.getParameter("c_cap_tot")));
		c_fin.setC_sale		(request.getParameter("c_sale").equals("")?0:AddUtil.parseDigit2(request.getParameter("c_sale")));
		c_fin.setF_kisu		(request.getParameter("f_kisu")==null?"":request.getParameter("f_kisu"));
		c_fin.setF_ba_year	(request.getParameter("f_ba_year")==null?"":AddUtil.ChangeString(request.getParameter("f_ba_year")));
		c_fin.setF_asset_tot	(request.getParameter("f_asset_tot").equals("")?0:AddUtil.parseDigit2(request.getParameter("f_asset_tot")));
		c_fin.setF_cap		(request.getParameter("f_cap").equals("")?0:AddUtil.parseDigit2(request.getParameter("f_cap")));
		c_fin.setF_cap_tot	(request.getParameter("f_cap_tot").equals("")?0:AddUtil.parseDigit2(request.getParameter("f_cap_tot")));
		c_fin.setF_sale		(request.getParameter("f_sale").equals("")?0:AddUtil.parseDigit2(request.getParameter("f_sale")));
		c_fin.setC_profit	(request.getParameter("c_profit").equals("")?0:AddUtil.parseDigit2(request.getParameter("c_profit")));
		c_fin.setF_profit	(request.getParameter("f_profit").equals("")?0:AddUtil.parseDigit2(request.getParameter("f_profit")));
		c_fin.setC_ba_year_s 	(request.getParameter("c_ba_year_s")==null?"":AddUtil.ChangeString(request.getParameter("c_ba_year_s")));
		c_fin.setF_ba_year_s 	(request.getParameter("f_ba_year_s")==null?"":AddUtil.ChangeString(request.getParameter("f_ba_year_s")));
			

			
		//입력값이 있으면..
		if(!c_fin.getC_ba_year().equals("")){
			
			if(c_fin.getF_seq().equals("")){
				flag2 = al_db.insertClientFin(c_fin);
			}else{
				flag2 = al_db.updateClientFin(c_fin);
			}
		}
		
	}

	//3. 계약기타정보-----------------------------------------------------------------------------------------------
	
	//cont_etc  update 
	ContEtcBean etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	etc.setDec_gr		(dec_gr);
	etc.setDec_f_id		(request.getParameter("dec_f_id")==null?"":request.getParameter("dec_f_id"));
	etc.setDec_f_dt		(request.getParameter("dec_f_dt")==null?"":AddUtil.ChangeString(request.getParameter("dec_f_dt")));
	etc.setDec_l_id		(request.getParameter("dec_l_id")==null?"":request.getParameter("dec_l_id"));
	etc.setDec_l_dt		(request.getParameter("dec_l_dt")==null?"":AddUtil.ChangeString(request.getParameter("dec_l_dt")));
	etc.setDec_etc		(request.getParameter("dec_etc")==null?"":request.getParameter("dec_etc"));
	
	if(!client_st.equals("2")){
		if(c_fin.getF_seq().equals("")){
			etc.setFin_seq	(al_db.getClientFinSeq(client_id, c_fin.getC_kisu(), c_fin.getC_ba_year()));
		}else{
			etc.setFin_seq	(c_fin.getF_seq());
		}
	}
	
	//=====[cont_etc] update=====
	flag3 = a_db.updateContEtc(etc);


	//4. 계약고객평가 [cont_eval]-------------------------------------------------------------------------------------
	 
	String eval_gu[] 	= request.getParameterValues("eval_gu");
	String eval_nm[] 	= request.getParameterValues("eval_nm");
	String eval_score[] 	= request.getParameterValues("eval_score");
	String eval_gr[] 	= request.getParameterValues("eval_gr");
	String eval_off[] 	= request.getParameterValues("eval_off");
	String eval_s_dt[] 	= request.getParameterValues("eval_s_dt");
	String ass1_type[] 	= request.getParameterValues("ass1_type");
	String ass2_type[] 	= request.getParameterValues("ass2_type");
	String eval_b_dt[] 	= request.getParameterValues("eval_b_dt");
	
	String t_zip[] 		= request.getParameterValues("t_zip");
	String t_addr[] 	= request.getParameterValues("t_addr");
	
	int gur_size = eval_gu.length;
	
	//out.println(gur_size);
	
	
	for(int i = 0 ; i < gur_size ; i++){
	
		out.println(eval_gu[i]);
		
		if(!eval_gu[i].equals("")){
		
			
			ContEvalBean eval = a_db.getContEval(rent_mng_id, rent_l_cd, eval_gu[i], "");
			
			eval.setE_seq		(String.valueOf(i));
			eval.setEval_gu		(eval_gu[i]);
			eval.setEval_nm		(eval_nm[i]);
			eval.setEval_score		(eval_score[i]);
			eval.setEval_gr		(eval_gr[i]);
			eval.setEval_off	(eval_off[i]);
			eval.setEval_s_dt	(eval_s_dt[i]);			
			eval.setAss1_type	(ass1_type[i]);
			eval.setAss2_type	(ass2_type[i]);
			eval.setAss1_addr	(t_addr[i*2]);
			eval.setAss1_zip	(t_zip[i*2]);
			eval.setAss2_addr	(t_addr[i*2+1]);
			eval.setAss2_zip	(t_zip[i*2+1]);			
			eval.setEval_b_dt	(eval_b_dt[i]);
			
			
			if(eval.getRent_l_cd().equals("")){
				eval.setRent_mng_id	(rent_mng_id);
				eval.setRent_l_cd	(rent_l_cd);
				eval.setE_seq		(String.valueOf(i));
				//=====[CONT_EVAL] insert=====
				flag4 = a_db.insertContEval(eval);
			
				//out.println("insertContEval");	
			}else{
				//=====[CONT_EVAL] update=====
				flag4 = a_db.updateContEval(eval);
				//out.println("updateContEval");
			}
			
		}
	}
	
	//if(1==1)return;

	//5. 고객정보 [client]-----------------------------------------------------------------------------------------
	if(client_st.equals("2")){		
		client.setCom_nm	(request.getParameter("com_nm")==null?"":request.getParameter("com_nm"));
		client.setJob		(request.getParameter("job")==null?"":request.getParameter("job"));
		client.setPay_st	(request.getParameter("pay_st")==null?"":request.getParameter("pay_st"));
		client.setPay_type	(request.getParameter("pay_type")==null?"":request.getParameter("pay_type"));
		client.setWk_year	(request.getParameter("wk_year")==null?"":request.getParameter("wk_year"));
		flag5 = al_db.updateNewClient2(client);
	}
%>
<form name='form1' action='' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type='hidden' name="old_rent_mng_id" 	value="<%=old_rent_mng_id%>">
  <input type='hidden' name="old_rent_l_cd" 	value="<%=old_rent_l_cd%>">
</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(!flag1 || !flag2 || !flag3 || !flag4 || !flag5 ){	%>
		alert('에러가 발생하였습니다. \n\n확인하십시오');
<%	}else{	%>
		alert("등록되었습니다");
		fm.action = 'lc_reg_step4.jsp';
		fm.target = 'd_content';
		fm.submit();
	
<%	}	%>
</script>
</body>
</html>
