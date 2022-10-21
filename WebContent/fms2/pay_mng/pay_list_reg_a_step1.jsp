<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.cus0601.*, acar.bill_mng.*, card.*"%>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp"%>


<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	Cus0601_Database 	c61_db 	= Cus0601_Database.getInstance();
	PayMngDatabase 		pm_db 	= PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	
	String pay_gubun 	= request.getParameter("pay_gubun")	==null?"":request.getParameter("pay_gubun");
	String pay_est_dt	= request.getParameter("pay_est_dt")==null?AddUtil.getDate():request.getParameter("pay_est_dt");
	String g_bank_id 	= request.getParameter("g_bank_id")	==null?"":request.getParameter("g_bank_id");
	String g_bank_nm 	= request.getParameter("g_bank_nm")	==null?"":request.getParameter("g_bank_nm");
	String g_bank_no	= request.getParameter("g_bank_no")	==null?"":request.getParameter("g_bank_no");
	String p_est_dt 	= request.getParameter("p_est_dt")	==null?"":request.getParameter("p_est_dt");
	String mode			= request.getParameter("mode")		==null?"":request.getParameter("mode");
	
	String cardno		= request.getParameter("cardno")		==null?"":request.getParameter("cardno");
	
	String reqseq		= "";
	
	
	
	String value01[] = request.getParameterValues("p_st1");
	String value02[] = request.getParameterValues("p_st2");
	String value03[] = request.getParameterValues("p_st3");
	String value04[] = request.getParameterValues("p_cd1");
	String value05[] = request.getParameterValues("p_cd2");
	String value06[] = request.getParameterValues("p_cd3");
	String value07[] = request.getParameterValues("amt");
	String value08[] = request.getParameterValues("bank_nm");
	String value09[] = request.getParameterValues("bank_no");
	String value10[] = request.getParameterValues("off_st");
	String value11[] = request.getParameterValues("off_id");
	String value12[] = request.getParameterValues("off_nm");
	String value13[] = request.getParameterValues("p_cont");
	String value14[] = request.getParameterValues("p_way");
	String value15[] = request.getParameterValues("p_cd4");
	String value16[] = request.getParameterValues("p_cd5");
	String value17[] = request.getParameterValues("p_st4");
	String value18[] = request.getParameterValues("p_st5");
	String value19[] = request.getParameterValues("est_dt");
	String value20[] = request.getParameterValues("ven_code");
	String value21[] = request.getParameterValues("ven_name");
	String value22[] = request.getParameterValues("bank_id");
	String value23[] = request.getParameterValues("sub_amt1");
	String value24[] = request.getParameterValues("sub_amt2");
	String value25[] = request.getParameterValues("sub_amt3");
	String value26[] = request.getParameterValues("card_id");
	String value27[] = request.getParameterValues("card_nm");
	String value28[] = request.getParameterValues("card_no");
	String value29[] = request.getParameterValues("sub_amt4");
	String value30[] = request.getParameterValues("sub_amt5");
	String value31[] = request.getParameterValues("a_bank_id");
	String value32[] = request.getParameterValues("a_bank_nm");
	String value33[] = request.getParameterValues("a_bank_no");
	String value34[] = request.getParameterValues("buy_user_id");
	String value35[] = request.getParameterValues("s_idno");
	String value36[] = request.getParameterValues("acct_code");
	String value37[] = request.getParameterValues("bank_acc_nm");
	String value38[] = request.getParameterValues("bank_cms_bk");
	String value39[] = request.getParameterValues("a_bank_cms_bk");
	String value40[] = request.getParameterValues("off_tel");
	String value41[] = request.getParameterValues("sub_amt6");
	
	
	String search_code  = Long.toString(System.currentTimeMillis());
	
	int vid_size = value01.length;
	
	int flag = 0;
	
	int reg_chk = 0;
	int t_reg_chk = 0;
	
	
	for(int i=0; i<vid_size;i++){
		
		if(!value01[i].equals("")){
		
			PayMngBean bean = new PayMngBean();
			
			bean.setReqseq		("");
			bean.setP_est_dt	(value19[i]==null?"":value19[i]);
		
			if(!p_est_dt.equals(""))	bean.setP_est_dt(p_est_dt);
		
			bean.setP_gubun		(pay_gubun);
			bean.setP_st1		(value01[i]==null?"":value01[i]);
			bean.setP_st2		(value02[i]==null?"":value02[i]);
			bean.setP_st3		(value03[i]==null?"":value03[i]);
			bean.setP_cd1		(value04[i]==null?"":value04[i]);
			bean.setP_cd2		(value05[i]==null?"":value05[i]);
			bean.setP_cd3		(value06[i]==null?"":value06[i]);
			bean.setAmt			(value07[i]==null?0:AddUtil.parseDigit4(value07[i]));
			bean.setBank_nm		(value08[i]==null?"":value08[i]);
			bean.setBank_no		(value09[i]==null?"":value09[i]);
			bean.setOff_st		(value10[i]==null?"":value10[i]);
			bean.setOff_id		(value11[i]==null?"":value11[i]);
			bean.setOff_nm		(value12[i]==null?"":value12[i]);
			bean.setP_cont		(value13[i]==null?"":value13[i]);
			bean.setP_way		(value14[i]==null?"":value14[i]);
			bean.setP_cd4		(value15[i]==null?"":value15[i]);
			bean.setP_cd5		(value16[i]==null?"":value16[i]);
			bean.setP_st4		(value17[i]==null?"":value17[i]);
			bean.setP_st5		(value18[i]==null?"":value18[i]);
			bean.setVen_code	(value20[i]==null?"":value20[i]);
			bean.setVen_name	(value21[i]==null?"":value21[i]);
			bean.setBank_id		(value22[i]==null?"":value22[i]);
			bean.setSub_amt1	(value23[i]==null?0:AddUtil.parseDigit4(value23[i]));
			bean.setSub_amt2	(value24[i]==null?0:AddUtil.parseDigit4(value24[i]));
			bean.setSub_amt3	(value25[i]==null?0:AddUtil.parseDigit4(value25[i]));
			bean.setCard_id		(value26[i]==null?"":value26[i]);
			bean.setCard_nm		(value27[i]==null?"":value27[i]);
			bean.setCard_no		(value28[i]==null?"":value28[i]);
			bean.setSub_amt4	(value29[i]==null?0:AddUtil.parseDigit4(value29[i]));
			bean.setSub_amt5	(value30[i]==null?0:AddUtil.parseDigit4(value30[i]));
			bean.setA_bank_id	(value31[i]==null?"":value31[i]);
			bean.setA_bank_nm	(value32[i]==null?"":value32[i]);
			bean.setA_bank_no	(value33[i]==null?"":value33[i]);
			bean.setBuy_user_id	(value34[i]==null?"":value34[i]);
			bean.setS_idno		(value35[i]==null?"":value35[i]);
			bean.setAcct_code	(value36[i]==null?"":value36[i]);
			bean.setBank_acc_nm	(value37[i]==null?"":value37[i]);
			bean.setBank_cms_bk	(value38[i]==null?"":value38[i]);
			bean.setA_bank_cms_bk(value39[i]==null?"":value39[i]);
			bean.setOff_tel		(value40[i]==null?"":value40[i]);
			bean.setSub_amt6	(value41[i]==null?0:AddUtil.parseDigit4(value41[i]));			
			bean.setP_step		("0");
			bean.setReg_st		("S");
			bean.setReg_id		(user_id);
			bean.setSearch_code	(search_code);
		
			if(bean.getBank_cms_bk().equals("null")) 	bean.setBank_cms_bk("");
			if(bean.getA_bank_cms_bk().equals("null")) 	bean.setA_bank_cms_bk("");
			if(bean.getA_bank_id().equals("null")) 		bean.setA_bank_id("");
			if(bean.getA_bank_nm().equals("null")) 		bean.setA_bank_nm("");
			if(bean.getA_bank_no().equals("null")) 		bean.setA_bank_no("");
		
			if(bean.getBank_no().equals("")){
				bean.setBank_acc_nm("");
			}
			if(bean.getP_gubun().equals("11")){
				bean.setVen_st	("1");
			}else{
				bean.setVen_st	("0");
			}
			bean.setTax_yn		("N");
			bean.setAcct_code_st("1");
		
			if(bean.getP_gubun().equals("15") || bean.getP_gubun().equals("16")){
				bean.setTax_yn	("Y");
			}
		
			//계좌이체(지출처) 은행코드-code
			if(!bean.getBank_nm().equals("") && bean.getP_way().equals("5")){
				Hashtable ht = ps_db.getBankCode("", bean.getBank_nm());
				if(String.valueOf(ht.get("CMS_BK")).equals("null")){
				}else{
					bean.setBank_cms_bk(String.valueOf(ht.get("CMS_BK")));
					bean.setBank_id(String.valueOf(ht.get("CMS_BK")));
				}
			}
			//계좌이체(지출처) 은행코드-네오엠
			if(bean.getBank_id().equals("") && !bean.getBank_nm().equals("") && bean.getP_way().equals("5")){
				Hashtable ht = ps_db.getCheckd("A03", bean.getBank_nm());
				if(String.valueOf(ht.get("CHECKD_CODE")).equals("null")){
				}else{
					bean.setBank_id(String.valueOf(ht.get("CHECKD_CODE")));
				}
			}
		
			//자동이체(당사) 은행코드
			if(bean.getA_bank_id().equals("") && !bean.getA_bank_no().equals("")){
				Hashtable ht = ps_db.getDepositma(bean.getA_bank_no());
				if(String.valueOf(ht.get("BANK_CODE")).equals("null")){
				}else{
					bean.setA_bank_id(String.valueOf(ht.get("BANK_CODE")));
					bean.setA_bank_nm(String.valueOf(ht.get("CHECKD_NAME")));
				}
			}
			//계좌이체(지출처) 은행코드-code
			if(!bean.getA_bank_nm().equals("") && bean.getP_way().equals("5")){
				Hashtable ht = ps_db.getBankCode("", bean.getA_bank_nm());
				if(String.valueOf(ht.get("CMS_BK")).equals("null")){
				}else{
					bean.setA_bank_cms_bk(String.valueOf(ht.get("CMS_BK")));
				}
			}
		
			//네오엠거래처-정비업체
			if(bean.getVen_code().equals("") && bean.getOff_st().equals("off_id")){
			
				c61_soBn = c61_db.getServOff(bean.getOff_id());
				String ven_code = neoe_db.getVenCode2("", c61_soBn.getEnt_no());
				if(!ven_code.equals("")){
					bean.setVen_code(ven_code);
					if(bean.getVen_name().equals("")){
						Hashtable ht = neoe_db.getVendorCase(ven_code);
						bean.setVen_name(String.valueOf(ht.get("VEN_NAME")));
					}
				}
			}
			
			reg_chk = 0;
			
			//사전계약계약금인 경우
			if(pay_gubun.equals("07") || pay_gubun.equals("08")){
				//후불카드
				if(bean.getP_way().equals("3")){
					if(cardno.equals("")){
						reg_chk = 1;
						t_reg_chk = t_reg_chk + 1;
					}else{
						//입력받은 일괄처리 카드 연동처리
						
						//카드정보
						CardBean c_bean = CardDb.getCard(cardno);
						
						bean.setOff_id		(c_bean.getCom_code());
						bean.setOff_nm		(c_bean.getCom_name());
						bean.setVen_code	(c_bean.getCom_code());
						bean.setVen_name	(c_bean.getCom_name());
						bean.setCard_id		(c_bean.getCom_code());
						bean.setCard_nm		(c_bean.getCard_kind());
						bean.setCard_no		(cardno);
						
						if(bean.getA_bank_id().equals("")){
							bean.setA_bank_id	("026");
							bean.setA_bank_nm	("신한");
							bean.setA_bank_no	("140-004-023871");
						}
						
						
					}
				}
			}
		
		
			if(AddUtil.lengthb(bean.getVen_name()) > 30 )	bean.setVen_name	(AddUtil.substringb(bean.getVen_name(),30 ));
			if(AddUtil.lengthb(bean.getP_cont())   > 100)	bean.setP_cont		(AddUtil.substringb(bean.getP_cont(),  100));
		
			if(reg_chk == 1){
				
			}else{
				reqseq = pm_db.insertPaySearch(bean);
			}	
			
		}	
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'pay_list_reg_a_step2.jsp';
		fm.target = '_self';
		
		<%if(t_reg_chk >0){%>
		alert('사전계약계약금 카드 선택이 되지 않았습니다.');
		<%}else{%>
		fm.submit();
		<%}%>
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' target='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='search_code' value='<%=search_code%>'>
</form>
<script language='javascript'>
<!--
<%	if(reqseq.equals("")){//에러발생%>
		<%if(t_reg_chk >0){%>
		alert('사전계약계약금 카드 선택이 되지 않았습니다.');
		<%}else{%>
		alert("에러가 발생하였습니다.");
		<%}%>
<%	}else{//정상%>
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
