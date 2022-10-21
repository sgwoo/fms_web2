<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.car_register.*, acar.con_ins.*" %>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="is_bean" class="acar.con_ins.InsurBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language="javascript">
<!--
	function ChangeSche()
	{
		var theForm = document.InsurForm;
		var arg = theForm.pay_tm.value;
//		theForm.ins_est_dt0.value = theForm.ins_start_dt_yr.value+"-"+theForm.ins_start_dt_mth.value+"-"+theForm.ins_start_dt_day.value;		
//		theForm.ins_est_dt0.value = theForm.ins_start_dt.value;		
		AddDate('1');
		if(arg=="1"){		
			insuSche1.style.display = "";
			insuSche2.style.display = "none";
			insuSche3.style.display = "none";
			insuSche4.style.display = "none";
			insuSche5.style.display = "none";
			insuSche6.style.display = "none";
			theForm.pay_amt0.value = theForm.tot_amt.value; 
		}else if(arg=="2"){
			insuSche1.style.display = "";
			insuSche2.style.display = "";
			insuSche3.style.display = "none";
			insuSche4.style.display = "none";
			insuSche5.style.display = "none";
			insuSche6.style.display = "none";
			theForm.pay_amt0.value = "";
		}else if(arg=="3"){
			insuSche1.style.display = "";
			insuSche2.style.display = "";
			insuSche3.style.display = "";
			insuSche4.style.display = "none";
			insuSche5.style.display = "none";
			insuSche6.style.display = "none";
			theForm.pay_amt0.value = "";
			theForm.pay_amt1.value = "";
		}else if(arg=="4"){
			insuSche1.style.display = "";
			insuSche2.style.display = "";
			insuSche3.style.display = "";
			insuSche4.style.display = "";
			insuSche5.style.display = "none";
			insuSche6.style.display = "none";
			theForm.pay_amt0.value = "";
		}else if(arg=="5"){
			insuSche1.style.display = "";
			insuSche2.style.display = "";
			insuSche3.style.display = "";
			insuSche4.style.display = "";
			insuSche5.style.display = "";
			insuSche6.style.display = "none";
			theForm.pay_amt0.value = "";
		}else if(arg=="6"){
			insuSche1.style.display = "";
			insuSche2.style.display = "";
			insuSche3.style.display = "";
			insuSche4.style.display = "";
			insuSche5.style.display = "";
			insuSche6.style.display = "";
			theForm.pay_amt0.value = "";
			theForm.pay_amt1.value = "";
			theForm.pay_amt2.value = "";
		}
	}
	
	function init(){
		var theForm = document.InsurForm;
		self.focus();
	}
	
	//등록,수정
	function InsurReg(){
		var theForm = document.InsurForm;
		var cmd = theForm.cmd.value;
		if(cmd=="id"){
			if(!confirm('등록하시겠습니까?')){	return;	}
			if(theForm.ins_com_id.value == ''){ alert('보험사를 선택하십시오.'); return;}
//			theForm.ins_start_dt.value = theForm.ins_start_dt_yr.value + theForm.ins_start_dt_mth.value + theForm.ins_start_dt_day.value;
//			theForm.ins_exp_dt.value = theForm.ins_exp_dt_yr.value + theForm.ins_exp_dt_mth.value + theForm.ins_exp_dt_day.value;
			theForm.cmd.value = "i";
			theForm.ins_st.value = "0";
		}else if(cmd=="udp"){
			if(!confirm('수정하시겠습니까?')){	return;	}		
//			theForm.ins_start_dt.value = theForm.ins_start_dt_yr.value + theForm.ins_start_dt_mth.value + theForm.ins_start_dt_day.value;
//			theForm.ins_exp_dt.value = theForm.ins_exp_dt_yr.value + theForm.ins_exp_dt_mth.value + theForm.ins_exp_dt_day.value;
			theForm.cmd.value = "u";
		}
		theForm.target = "i_no";
		theForm.submit();
	}
	
	function ChangeIns(arg){
		var theForm = document.InsurForm;
		var tot_amt = toInt(parseDigit(theForm.tot_amt.value));
		var pay_tm = theForm.pay_tm.value;
		if(pay_tm=="2"){
			if(arg=="1"){	
				theForm.pay_amt1.value = parseDecimal( tot_amt - toInt(parseDigit(theForm.pay_amt0.value)) );	
			}
		}else if(pay_tm=="3"){
			if(arg=="2"){	
				theForm.pay_amt2.value = parseDecimal( tot_amt - toInt(parseDigit(theForm.pay_amt0.value)) - toInt(parseDigit(theForm.pay_amt1.value)) );	
			}
		}else if(pay_tm=="6"){
			if(arg=="5"){	
				theForm.pay_amt5.value = parseDecimal( tot_amt - toInt(parseDigit(theForm.pay_amt0.value)) - toInt(parseDigit(theForm.pay_amt1.value)) - toInt(parseDigit(theForm.pay_amt2.value)) - toInt(parseDigit(theForm.pay_amt3.value)) - toInt(parseDigit(theForm.pay_amt4.value)) );	
			}
		}
	}

	function ChangeAmt(){
		var theForm = document.InsurForm;

		theForm.vins_tot_amt.value = parseDecimal(toInt(parseDigit(theForm.vins_pcp_amt.value))
								+ toInt(parseDigit(theForm.vins_gcp_amt.value))
								+ toInt(parseDigit(theForm.vins_bacdt_amt.value))
								+ toInt(parseDigit(theForm.vins_canoisr_amt.value))
								+ toInt(parseDigit(theForm.vins_cacdt_cm_amt.value))
								+ toInt(parseDigit(theForm.vins_spe_amt.value)));
								//+ parseInt(theForm.vins_cacdt_amt.value);
										
		theForm.tot_amt.value = parseDecimal(toInt(parseDigit(theForm.rins_pcp_amt.value))
								+ toInt(parseDigit(theForm.vins_pcp_amt.value))
								+ toInt(parseDigit(theForm.vins_gcp_amt.value))
								+ toInt(parseDigit(theForm.vins_bacdt_amt.value))
								+ toInt(parseDigit(theForm.vins_canoisr_amt.value))
								+ toInt(parseDigit(theForm.vins_spe_amt.value))
								+ toInt(parseDigit(theForm.vins_cacdt_cm_amt.value)));
								//+ parseInt(theForm.vins_cacdt_amt.value);
	}

	function AddDate(arg){
		var theForm = document.InsurForm;	
		if(arg=="1"){
			reg_dt = theForm.ins_est_dt0.value;
			theForm.pay_dt0.value = ChangeDate(reg_dt);
			parent.i_no.location ='./i_null.jsp?reg_date=' + reg_dt;					
		}
		theForm.ins_est_dt0.value = ChangeDate(reg_dt);
	}

	function ChangeTestDT(){
		var theForm = document.InsurForm;
		//추가
		theForm.ins_exp_dt_yr.value = parseInt(theForm.ins_start_dt_yr.value)+1;
		theForm.ins_exp_dt_mth.value = theForm.ins_start_dt_mth.value;
		var day_all = getMonthDateCnt(theForm.ins_exp_dt_yr.value, theForm.ins_exp_dt_mth.value);
		for(i=0; i<day_all; i++){
			theForm.ins_exp_dt_day[i] = new Option(i+1, ChangeNum(i+1));
		}		
		theForm.ins_exp_dt_day.value = theForm.ins_start_dt_day.value;		
	}

	//스캔 보기
	function view_map(idx){
		if(idx == '2'){	 			
			var map_path = document.InsurForm.scan.value;
			var size = 'width=700, height=650, scrollbars=yes';
			window.open("http://211.238.135.5/data/ins/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
		}else{
			document.InsurForm.scan_del.value = '1';
			return;
		}
	}		
	function ReLoadIns(){
		var fm = document.InsurForm;			
		fm.action="./register_ins_id.jsp"; 
		fm.target = "Ins";
		fm.submit();
	}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body onLoad="init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String rpt_no = request.getParameter("rpt_no")==null?"":request.getParameter("rpt_no");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int imm_amt = request.getParameter("imm_amt")==null?0:Util.parseInt(request.getParameter("imm_amt"));
	int count = 0;

	String ins_st = "";			//보험구분
	String ins_sts = "";		//상태
	String age_scp = request.getParameter("age_scp")==null?"":request.getParameter("age_scp");
	String car_use = request.getParameter("car_use")==null?"":request.getParameter("car_use");
	String ins_com_id = request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id");
	String ins_con_no = request.getParameter("ins_con_no")==null?"":request.getParameter("ins_con_no");
	String conr_nm = request.getParameter("conr_nm")==null?"":request.getParameter("conr_nm");
	String ins_start_dt = request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt");
	String ins_exp_dt = request.getParameter("ins_exp_dt")==null?"":request.getParameter("ins_exp_dt");
	int rins_pcp_amt = request.getParameter("rins_pcp_amt")==null?0:Util.parseInt(request.getParameter("rins_pcp_amt"));
	int vins_pcp_amt = request.getParameter("vins_pcp_amt")==null?0:Util.parseInt(request.getParameter("vins_pcp_amt"));
	String vins_pcp_kd = request.getParameter("vins_pcp_kd")==null?"1":request.getParameter("vins_pcp_kd");
	int vins_gcp_amt = request.getParameter("vins_gcp_amt")==null?0:Util.parseInt(request.getParameter("vins_gcp_amt"));
	String vins_gcp_kd = request.getParameter("vins_gcp_kd")==null?"1":request.getParameter("vins_gcp_kd");
	int vins_bacdt_amt = request.getParameter("vins_bacdt_amt")==null?0:Util.parseInt(request.getParameter("vins_bacdt_amt"));
	String vins_bacdt_kd = request.getParameter("vins_bacdt_kd")==null?"3":request.getParameter("vins_bacdt_kd");
	String vins_bacdt_kc2 = request.getParameter("vins_bacdt_kc2")==null?"4":request.getParameter("vins_bacdt_kc2");
	int vins_cacdt_amt = request.getParameter("vins_cacdt_amt")==null?0:Util.parseInt(request.getParameter("vins_cacdt_amt"));
	int vins_canoisr_amt = request.getParameter("vins_canoisr_amt")==null?0:Util.parseInt(request.getParameter("vins_canoisr_amt"));
	int vins_cacdt_car_amt = request.getParameter("vins_cacdt_car_amt")==null?0:Util.parseInt(request.getParameter("vins_cacdt_car_amt"));
	int vins_cacdt_me_amt = request.getParameter("vins_cacdt_me_amt")==null?0:Util.parseInt(request.getParameter("vins_cacdt_me_amt"));
	int vins_cacdt_cm_amt = request.getParameter("vins_cacdt_cm_amt")==null?0:Util.parseInt(request.getParameter("vins_cacdt_cm_amt"));
	int vins_tot_amt = 0;
	int tot_amt = 0;
	String pay_tm = request.getParameter("pay_tm")==null?"":request.getParameter("pay_tm");
	String change_dt = request.getParameter("change_dt")==null?"":request.getParameter("change_dt");
	String change_cau = request.getParameter("change_cau")==null?"":request.getParameter("change_cau");
	String change_itm_kd1 = request.getParameter("change_itm_kd1")==null?"":request.getParameter("change_itm_kd1");
	int change_itm_amt1 = request.getParameter("change_itm_amt1")==null?0:Util.parseInt(request.getParameter("change_itm_amt1"));
	String change_itm_kd2 = request.getParameter("change_itm_kd2")==null?"":request.getParameter("change_itm_kd2");
	int change_itm_amt2 = request.getParameter("change_itm_amt2")==null?0:Util.parseInt(request.getParameter("change_itm_amt2"));
	String change_itm_kd3 = request.getParameter("change_itm_kd3")==null?"":request.getParameter("change_itm_kd3");
	int change_itm_amt3 = request.getParameter("change_itm_amt3")==null?0:Util.parseInt(request.getParameter("change_itm_amt3"));
	String change_itm_kd4 = request.getParameter("change_itm_kd4")==null?"":request.getParameter("change_itm_kd4");
	int change_itm_amt4 = request.getParameter("change_itm_amt4")==null?0:Util.parseInt(request.getParameter("change_itm_amt4"));
	String car_rate = request.getParameter("car_rate")==null?"":request.getParameter("car_rate");
	String ins_rate = request.getParameter("ins_rate")==null?"":request.getParameter("ins_rate");
	String ext_rate = request.getParameter("ext_rate")==null?"":request.getParameter("ext_rate");
	String air_ds_yn = request.getParameter("air_ds_yn")==null?"":request.getParameter("air_ds_yn");
	String air_as_yn = request.getParameter("air_as_yn")==null?"":request.getParameter("air_as_yn");
	String agnt_nm = request.getParameter("agnt_nm")==null?"":request.getParameter("agnt_nm");
	String agnt_tel = request.getParameter("agnt_tel")==null?"":request.getParameter("agnt_tel");
	String agnt_imgn_tel = request.getParameter("agnt_imgn_tel")==null?"":request.getParameter("agnt_imgn_tel");
	String agnt_fax = request.getParameter("agnt_fax")==null?"":request.getParameter("agnt_fax");
	String exp_dt = request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt");
	String exp_cau = request.getParameter("exp_cau")==null?"":request.getParameter("exp_cau");
	int rtn_amt = request.getParameter("rtn_amt")==null?0:Util.parseInt(request.getParameter("rtn_amt"));
	String rtn_dt = request.getParameter("rtn_dt")==null?"":request.getParameter("rtn_dt");
	String vins_spe = request.getParameter("vins_spe")==null?"":request.getParameter("vins_spe");
	int vins_spe_amt = request.getParameter("vins_spe_amt")==null?0:Util.parseInt(request.getParameter("vins_spe_amt"));
	String scan = request.getParameter("scan_file")==null?"":request.getParameter("scan_file");
	String update_id = request.getParameter("update_id")==null?"":request.getParameter("update_id");
	String update_dt = request.getParameter("update_dt")==null?"":request.getParameter("update_dt");
	String con_f_nm = request.getParameter("con_f_nm")==null?"아마존카":request.getParameter("con_f_nm");

	//보험정보
	is_bean = ai_db.getIns(car_mng_id, "0");
	//보험스케줄
	Vector ins_scd = ai_db.getInsScds(car_mng_id, "0");
	int ins_scd_size = ins_scd.size();
	//보험사 리스트
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	AddCarRegDatabase a_crd = AddCarRegDatabase.getInstance();
	if(cmd.equals("ud")||cmd.equals("udp"))//보기 or 수정
	{
		if(a_crd.getInsurTF(car_mng_id)!=0)//보험 유
		{
//			is_bean = crd.getInsurBean(car_mng_id);
			car_mng_id = is_bean.getCar_mng_id();
			ins_st = is_bean.getIns_st();
			ins_sts = is_bean.getIns_sts();
			age_scp = is_bean.getAge_scp();
			car_use = is_bean.getCar_use();
			ins_com_id = is_bean.getIns_com_id();
			ins_con_no = is_bean.getIns_con_no();
			conr_nm = is_bean.getConr_nm();
			ins_start_dt = is_bean.getIns_start_dt();
			ins_exp_dt = is_bean.getIns_exp_dt();
			rins_pcp_amt = is_bean.getRins_pcp_amt();
			vins_pcp_amt = is_bean.getVins_pcp_amt();
			vins_pcp_kd = is_bean.getVins_pcp_kd();
			vins_gcp_amt = is_bean.getVins_gcp_amt();
			vins_gcp_kd = is_bean.getVins_gcp_kd();
			vins_bacdt_amt = is_bean.getVins_bacdt_amt();
			vins_bacdt_kd = is_bean.getVins_bacdt_kd();
			vins_bacdt_kc2 = is_bean.getVins_bacdt_kc2();
			vins_cacdt_amt = is_bean.getVins_cacdt_amt();
			vins_canoisr_amt = is_bean.getVins_canoisr_amt();
			vins_cacdt_car_amt = is_bean.getVins_cacdt_car_amt();
			vins_cacdt_me_amt = is_bean.getVins_cacdt_me_amt();
			vins_cacdt_cm_amt = is_bean.getVins_cacdt_cm_amt();
			pay_tm = is_bean.getPay_tm();
			change_dt = is_bean.getChange_dt();
			change_cau = is_bean.getChange_cau();
			change_itm_kd1 = is_bean.getChange_itm_kd1();
			change_itm_amt1 = is_bean.getChange_itm_amt1();
			change_itm_kd2 = is_bean.getChange_itm_kd2();
			change_itm_amt2 = is_bean.getChange_itm_amt2();
			change_itm_kd3 = is_bean.getChange_itm_kd3();
			change_itm_amt3 = is_bean.getChange_itm_amt3();
			change_itm_kd4 = is_bean.getChange_itm_kd4();
			change_itm_amt4 = is_bean.getChange_itm_amt4();
			car_rate = is_bean.getCar_rate();
			ins_rate = is_bean.getIns_rate();
			ext_rate = is_bean.getExt_rate();
			air_ds_yn = is_bean.getAir_ds_yn();
			air_as_yn = is_bean.getAir_as_yn();
			agnt_nm = is_bean.getAgnt_nm();
			agnt_tel = is_bean.getAgnt_tel();
			agnt_imgn_tel = is_bean.getAgnt_imgn_tel();
			agnt_fax = is_bean.getAgnt_fax();
			exp_dt = is_bean.getExp_dt();
			exp_cau = is_bean.getExp_cau();
			rtn_amt = is_bean.getRtn_amt();
			rtn_dt = is_bean.getRtn_dt();
			vins_spe = is_bean.getVins_spe();
			vins_spe_amt = is_bean.getVins_spe_amt();
			scan = is_bean.getScan_file();
			update_id = is_bean.getUpdate_id();
			update_dt = is_bean.getUpdate_dt();
			con_f_nm = is_bean.getCon_f_nm();
//			si_r = crd.getScdInsAll(car_mng_id, ins_st);
			vins_tot_amt = vins_pcp_amt + vins_gcp_amt + vins_bacdt_amt + vins_canoisr_amt + vins_cacdt_cm_amt + vins_spe_amt;
			tot_amt = vins_tot_amt + rins_pcp_amt;
		}
		else{//보험 무
			cmd="id";
		}
	}
%>
<form action="./register_ins_null_iu.jsp" name="InsurForm" method="post" enctype="multipart/form-data">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='ins_st' value='<%=ins_st%>'>
<input type='hidden' name='ins_scd_size' value='<%=ins_scd_size%>'>
<input type='hidden' name='scan' value='<%=scan%>'>
<input type='hidden' name='scan_del' value=''>
<%	if(cmd.equals("ud")){//보기%>
  <table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
	  <td class='line' colspan=3>		 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td width='120' class='title'>계약번호</td>
            <td width='100' align="center"><%= rent_l_cd %></td>
            <td width='80' class='title'>차량번호</td>
            <td width='100' align="center"><b><font color="#003399"><%= car_no %></font></b></td>
            <td width='100' class='title'>업체명</td>
            <td width='120' align="center"><%= firm_nm %></td>
            <td width='80' class='title'>고객명</td>
            <td width='100' align="center"><%= client_nm %></td>
          </tr>
          <tr> 
            <td class='title'>계약자</td>
            <td width='100' align="center"> 아마존카 </td>
            <td class='title'> 보험회사</td>
            <td> 
              <select name="ins_com_id" disabled>
                <%if(ic_size > 0){
					for(int i = 0 ; i < ic_size ; i++){
						InsComBean ic = ic_r[i];%>
                <option value="<%=ic.getIns_com_id()%>" <%if(ins_com_id.equals(ic.getIns_com_id())){%>selected<%}%>><%=ic.getIns_com_nm()%></option>
                <%	}
				}%>
              </select>
            </td>
            <td class='title'>보험계약번호</td>
            <td><%=ins_con_no%> 
              <input type='hidden' name="ins_con_no" value="<%=ins_con_no%>" size='10' class='text'>
            </td>
            <td width='80' class='title'>피보험자</td>
            <td width='100' align="center"><%= con_f_nm %></td>
          </tr>
          <tr> 
            <td class='title'> 연령범위 </td>
            <td> 
              <select name="age_scp" disabled>
                <option value="" <%if(age_scp.equals("")){%>selected<%}%>>선택</option>
              <option value="1" <%if(age_scp.equals("1")){%>selected<%}%>> 21세 이상 </option>
              <option value="2" <%if(age_scp.equals("2")){%>selected<%}%>> 26세 이상 </option>
              <option value="3" <%if(age_scp.equals("3")){%>selected<%}%>> 모든 운전자 </option>
              </select>
            </td>
            <td class='title'>차량용도</td>
            <td> 
              <select name="car_use" disabled>
                <option value="">선택</option>
                <option value="1" <%if(car_no.substring(4,5).equals("허") || car_use.equals("1")){%>selected<%}%>>영업용</option>
                <option value="2" <%if(!car_no.substring(4,5).equals("허") || car_use.equals("2")){%>selected<%}%>>업무용</option>
              </select>
            </td>
            <td class='title'>차종</td>
            <td colspan='3' align="center"><%=car_name%></td>
          </tr>
          <tr> 
            <td class='title'>보험기간</td>
            <td colspan='5'> 
              <input type="text" name="ins_start_dt" value="<%=AddUtil.ChangeDate2(ins_start_dt)%>" size="12" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
              &nbsp;24시&nbsp;&nbsp;~ &nbsp;&nbsp; 
              <input type="text" name="ins_exp_dt" value="<%=AddUtil.ChangeDate2(ins_exp_dt)%>" size="12" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
              &nbsp;24시			
            </td>
            <td class='title'>보험증스캔</td>
            <td align='center'> 
              <%if(!scan.equals("")){%>
              <input type="button" name="b_map2" value="보기" onClick="javascript:view_map(2);">
              <%}%>
            </td>
          </tr>
        </table>
	  </td>
	</tr>
	<tr>
	  <td align='left' width='410'><<보험료 사항>></td>
	  <td align='left' width='30'>&nbsp;</td>
	  <td align='left' width='360'><<보험료 납부>></td>
	</tr>
	<tr>
	  <td class='line' height='170'>			 
        <table border="0" cellspacing="1" cellpadding="0" width='410'>
          <tr> 
            <td class='title' width="30"> 책임<br>
              보험</td>
            <td class='star' width="70" align="center"> 대인배상</td>
            <td colspan="2"></td>
            <td align="right" width="90"><%=Util.parseDecimal(rins_pcp_amt)%> 
              <input type='hidden' name="rins_pcp_amt" value="<%=rins_pcp_amt%>" size='15' class='text' onChange="javascript:ChangeAmt()">
              원</td>
          </tr>
          <tr> 
            <td rowspan='10' class='title'> 임의<br>
              보험 </td>
            <td class='star' align="center"> 대인배상 </td>
            <td colspan="2"> 
              <select name="vins_pcp_kd" disabled>
                <option value="1">무한</option>
                <option value="2">유한</option>
              </select>
            </td>
            <td align="right"><%=Util.parseDecimal(vins_pcp_amt)%> 
              <input type='hidden' name="vins_pcp_amt" value="<%=vins_pcp_amt%>" size='15' class='text' onChange="javascript:ChangeAmt()">
              원</td>
          </tr>
          <tr> 
            <td class='star' align="center"> 대물배상 </td>
            <td colspan="2"> 
              <select name="vins_gcp_kd" disabled>
                <option value='2' >1500만원</option>			  
                <option value='1' >3000만원</option>				  				
                <option value="4">5000만원</option>									  				
                <option value='3' >1억원</option>					  				
              </select>
              (1사고당) 
            </td>
            <td align="right"><%=Util.parseDecimal(vins_gcp_amt)%> 
              <input type='hidden' name="vins_gcp_amt" value="<%=vins_gcp_amt%>" size='15' class='text' onChange="javascript:ChangeAmt()">
              원</td>
          </tr>
          <tr> 
            <td class='star' rowspan="2" align="center"> 자기신체<br>
              사고 </td>
            <td colspan="2"> 
              <select name="vins_bacdt_kd" disabled>
                <option value="4">1500만원</option>
                <option value="3">3000만원</option>
                <option value="5">5000만원</option>
                <option value='6' >1억원</option>					  																
                <option value="2">1억5천만원</option>
                <option value="1">3억원</option>
              </select>
              (1인당사망/장해) 
            </td>
            <td align="right" rowspan="2"><%=Util.parseDecimal(vins_bacdt_amt)%> 
              <input type='hidden' name="vins_bacdt_amt" value="<%=vins_bacdt_amt%>" size='15' class='text' onChange="javascript:ChangeAmt()">
              원</td>
          </tr>
          <tr> 
            <td colspan="2"> 
              <select name="vins_bacdt_kc2" disabled>
                <option value="4" selected>1500만원</option>				
                <option value="3">3000만원</option>
                <option value="5">5000만원</option>		
                <option value='6' >1억원</option>					  																										
                <option value="2">1억5천만원</option>
                <option value="1">3억원</option>
              </select>
              (1인당부상) 
            </td>
          </tr>
          <tr> 
            <td class='star' align="center"> 아마존카<br>보험</td>
            <td colspan="2">(자차면책금)</td>
            <td align="right"><%= Util.parseDecimal(imm_amt) %> 
              <input type='hidden' name="vins_cacdt_amt" value="<%= imm_amt %>" size='15' class='text' readonly>
              원</td>
          </tr>
          <tr> 
            <td class='star' align="center"> 무보험차<br>
              상해 </td>
            <td colspan="2">&nbsp;</td>
            <td align="right"> <%= Util.parseDecimal(vins_canoisr_amt) %> 
              <input type='hidden' name="vins_canoisr_amt" value="<%= vins_canoisr_amt %>" size='15' class='text' onChange="javascript:ChangeAmt()">
              원</td>
          </tr>
          <tr> 
            <td class='star' rowspan="2" align="center"> 자기차량<br>
              손해 </td>
            <td width="100"> 차량</td>
            <td align="right" width="120"><%= Util.parseDecimal(vins_cacdt_car_amt) %> 
              <input type='hidden' name="vins_cacdt_car_amt" value="<%= vins_cacdt_car_amt %>" size='15' class='text' >
              만원</td>
            <td align="right" rowspan="2"><%= Util.parseDecimal(vins_cacdt_cm_amt) %> 
              <input type='hidden' name="vins_cacdt_cm_amt" value="<%= vins_cacdt_cm_amt %>" size='15' class='text' onChange="javascript:ChangeAmt()">
              원 </td>
          </tr>
          <tr> 
            <td> 자기부담금 </td>
            <td align="right"><%= Util.parseDecimal(vins_cacdt_me_amt) %> 
              <input type='hidden' name="vins_cacdt_me_amt" value="<%= vins_cacdt_me_amt %>" size='15' class='text' >
              만원</td>
          </tr>
          <tr> 
            <td class='star' align="center"> 특약</td>
            <td colspan="2"><%=vins_spe%> 
              <input type='hidden' name="vins_spe" value="<%= vins_spe %>" size='15' class='text' readonly>
            </td>
            <td  align="right"><%=Util.parseDecimal(vins_spe_amt)%> 
              <input type='hidden' name="vins_spe_amt" value="<%= vins_spe_amt %>" size='20' class='text' readonly>
              원</td>
          </tr>
          <tr> 
            <td class='star' align="center"> 합계 </td>
            <td colspan="2"></td>
            <td  align="right"><%=Util.parseDecimal(vins_tot_amt)%> 
              <input type='hidden' name="vins_tot_amt" value="<%=vins_tot_amt%>" size='15' class='text' readonly>
              원</td>
          </tr>
          <tr> 
            <td class='title'> 납부<br>
              횟수 </td>
            <td> 
              <select name="pay_tm" disabled>
                <option value="">선택</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="6">6</option>
              </select>
              회 
			  <script>
					document.InsurForm.pay_tm.value = '<%=ins_scd_size%>';			  
			  </script>			  
            <td align=right colspan="2">합계&nbsp;&nbsp;</td>
            <td align=right><%=Util.parseDecimal(tot_amt)%> 
              <input type='hidden' name="tot_amt" value="<%=tot_amt%>">
              원</td>
          </tr>
        </table>
	  </td>		
      <td align='left' width='30'> </td>
	  <td valign=top>
		<table border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class=line>
			  <table border="0" cellspacing="1" cellpadding="0" width=360>
				<tr>
				  <td class='title'>회차</td>
				  <td class='title'>납부예정일</td>
				  <td class='title'>납부금액</td>
				  <td class='title'>납부일</td>
				</tr>
				<%for(int i = 0 ; i < ins_scd_size ; i++){
					InsurScdBean scd = (InsurScdBean)ins_scd.elementAt(i);%>
				<tr>
				  <td align="center"><%= scd.getIns_tm() %><input type="hidden" name="ins_tm<%=i%>" value="<%= scd.getIns_tm() %>"></td>
				  <td align="center"><%= scd.getIns_est_dt() %><input type='hidden' name="ins_est_dt<%=i%>" value="<%= scd.getIns_est_dt() %>" size='10' class='text'></td>
				  <td align="right"><%= Util.parseDecimal(scd.getPay_amt()) %>&nbsp;<input type='hidden' name="pay_amt<%=i%>" value="<%= scd.getPay_amt() %>" size='15' class='text'>원&nbsp;</td>
				  <td align="center"><%= scd.getPay_dt() %><input type='hidden' name="pay_dt<%=i%>" value="<%= scd.getPay_dt() %>" size='10' class='text'></td>
				</tr>
				<%}%>
			  </table>
			</td>
		  </tr>
		</table>		
	  </td>
	</tr>
	<tr>
	  <td align='left' colspan=3>	<<기타사항>>></td>
	</tr>
	<tr>
	  <td class='line' colspan=3>
		<table border="0" cellspacing="1" cellpadding="0" width=800>
		  <tr>
			<td class='title'> 가입경력율</td>
			<td align="center"><%=car_rate%><input type='hidden' name="car_rate" value="<%=car_rate%>" size='15' class='text'></td>
			<td class='title'>보험율</td>
			<td align="center" width="100"><%=ins_rate%><input type='hidden' name="ins_rate" value="<%=ins_rate%>" size='15' class='text'></td>
			<td class='title' width="100">할인할증율</td>
			<td align="center" width="100" colspan=3><%=ext_rate%><input type='hidden' name="ext_rate" value="<%=ext_rate%>" size='15' class='text'></td>					
		  </tr>
		  <tr>
			<td width="100" class='title' > 담당자	</td>
			<td width="100" align="center"><%=agnt_nm%><input type='hidden' name="agnt_nm" value="<%=agnt_nm%>" size='8' class='text'></td>
			<td width="100" class='title' > 전화번호	</td>
			<td width="100" align="center"><%=agnt_tel%><input type='hidden' name="agnt_tel" value="<%=agnt_tel%>" size='15' class='text'></td>
			<td width="100" class='title' > 긴급전화번호	</td>
			<td width="100" align="center"><%=agnt_imgn_tel%><input type='hidden' name="agnt_imgn_tel" value="<%=agnt_imgn_tel%>" size='15' class='text'></td>
			<td width="100" class='title' > 팩스	</td>
			<td width="100" align="center"><%=agnt_fax%><input type='hidden' name="agnt_fax" value="<%=agnt_fax%>" size='15' class='text'></td>
		  </tr>
		  <tr>
			<td class='title'> 에어백 </td>
			<td colspan='9'> 
			  <input type='radio' name='rdo_air' value="1" <% if(air_ds_yn.equals("Y")||air_as_yn.equals("Y")) out.println("checked"); %>>유 
			  (<input type='checkbox' name="air_ds_yn" value="Y" <% if(air_ds_yn.equals("Y")) out.println("checked"); %>> 운전석
			  <input type='checkbox' name="air_as_yn" value="Y"<% if(air_as_yn.equals("Y")) out.println("checked"); %>> 조수석)
			  <input type='radio' name='rdo_air' value="2" <% if(!(air_ds_yn.equals("Y")||air_as_yn.equals("Y"))) out.println("checked"); %>>무  
			</td>
		  </tr>			
		</table>
	  </td>
	</tr>
	<tr>	
	  <td align='right' colspan=3><a href="javascript:self.close();window.close();">닫기</a></td>
	</tr>
  </table>
<%	}else{%>
  <table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
	<td class='line' colspan=3>		 
      <table border="0" cellspacing="1" cellpadding="0" width=800>
        <tr> 
          <td width='120' class='title'>계약번호</td>
          <td width='100' align="center"><%= rent_l_cd %></td>
          <td width='80' class='title'>차량번호</td>
          <td width='100' align="center"><b><font color="#003399"><%= car_no %></font></b></td>
          <td width='100' class='title'>업체명</td>
          <td width='120' align="center"><%= firm_nm %></td>
          <td width='80' class='title'>고객명</td>
          <td width='100' align="center"><%= client_nm %></td>
        </tr>
        <tr> 
          <td class='title'>계약자</td>
          <td width='100' align="center"> 아마존카 </td>
          <td class='title'> 보험회사</td>
          <td> 
            <select name="ins_com_id">
              <option value="">선택</option>
              <%if(ic_size > 0){
					for(int i = 0 ; i < ic_size ; i++){
						InsComBean ic = ic_r[i];%>
              <option value="<%=ic.getIns_com_id()%>" <%if(ins_com_id.equals(ic.getIns_com_id())){%>selected<%}%>><%=ic.getIns_com_nm()%></option>
              <%	}
				}%>
            </select>
          </td>
          <td class='title'>보험계약번호</td>
          <td> 
            <input type='text' name="ins_con_no" value="<%=ins_con_no%>" size='15' class='text'>
          </td>
          <td width='80' class='title'>피보험자</td>
          <td width='100'><input type='text' name="con_f_nm" value="<%=con_f_nm%>" size='13' class='text'></td>
        </tr>
        <tr> 
          <td class='title'> 연령범위 </td>
          <td> 
            <select name="age_scp">
              <option value="">선택</option>
              <option value="1" <%if(age_scp.equals("1")){%>selected<%}%>> 21세 이상 </option>
              <option value="2" <%if(age_scp.equals("2") || age_scp.equals("")){%>selected<%}%>> 26세 이상 </option>
              <option value="3" <%if(age_scp.equals("3")){%>selected<%}%>> 모든 운전자 </option>
            </select>
          </td>
          <td class='title'>차량용도</td>
          <td> 
            <select name="car_use">
              <option value="">선택</option>
              <option value="1" <%if(car_no.substring(4,5).equals("허") || car_use.equals("1")){%>selected<%}%>>영업용</option>
              <option value="2" <%if(!car_no.substring(4,5).equals("허") || car_use.equals("2")){%>selected<%}%>>업무용</option>
            </select>
            </td>
            <td class='title'>차종</td>
            <td  colspan='3' align="center"><%=car_name%></td>
          </tr>
          <tr> 
            <td class='title'>보험기간</td>
            <td colspan='9'> 
              <input type="text" name="ins_start_dt" value="<%=AddUtil.ChangeDate2(ins_start_dt)%>" size="12" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
              &nbsp;24시&nbsp;&nbsp;~ &nbsp;&nbsp; 
              <input type="text" name="ins_exp_dt" value="<%=AddUtil.ChangeDate2(ins_exp_dt)%>" size="12" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
              &nbsp;24시			
            </td>
          </tr>
          <tr> 
            <td width='120' class='title'>보험증스캔</td>
            <td colspan="7"> 
              <input type="file" name="filename2" value="S" size="50">
              <%if(!scan.equals("")){%>
              &nbsp;&nbsp; 
              <input type="button" name="b_map2" value="보기" onClick="javascript:view_map(2);">
              &nbsp;&nbsp; 
              <input type="button" name="b_map3" value="삭제" onClick="javascript:view_map(3);">
              <%}%>
            </td>
          </tr>
        </table>
	  </td>
	</tr>
	<tr>
	  <td align='left' width='410'><<보험료 사항>></td>
	  <td align='left' width='30'>&nbsp;</td>
	  <td align='left' width='360'><<보험료 납부>></td>
	</tr>
	<tr>
	  <td class='line' height='170'>			 
        <table border="0" cellspacing="1" cellpadding="0" width='410'>
          <tr> 
            <td width=30 class='title'>책임<br>
              보험</td>
            <td width=70 class='star' align="center"> 대인배상</td>
            <td colspan="2"></td>
            <td width=90 align=right> 
              <input type='text' name="rins_pcp_amt" value="<%=Util.parseDecimal(rins_pcp_amt)%>" size='9' class='num' onBlur="javascript:this.value=parseDecimal(this.value); ChangeAmt()">
              원</td>
          </tr>
          <tr> 
            <td rowspan='10' class='title'> 임의<br>
              보험 </td>
            <td class='star' align="center"> 대인배상 </td>
            <td colspan="2"> 
              <select name="vins_pcp_kd" style="width:90px">
                <option value="1">무한</option>
                <option value="2">유한</option>
              </select>
            </td>
            <td align=right> 
              <input type='text' name="vins_pcp_amt" value="<%=Util.parseDecimal(vins_pcp_amt)%>" size='9' class='num' onBlur="javascript:this.value=parseDecimal(this.value); ChangeAmt()">
              원</td>
          </tr>
          <tr> 
            <td class='star' align="center"> 대물배상 </td>
            <td colspan="2"> 
              <select name="vins_gcp_kd" style="width:90px">
                <option value='2' >1500만원</option>			  
                <option value='1' >3000만원</option>				  				
                <option value="4">5000만원</option>									  				
                <option value='3' >1억원</option>					  				
              </select>
              &nbsp;(1사고당) 
            </td>
            <td align=right> 
              <input type='text' name="vins_gcp_amt" value="<%=Util.parseDecimal(vins_gcp_amt)%>" size='9' class='num' onBlur="javascript:this.value=parseDecimal(this.value); ChangeAmt()">
              원</td>
          </tr>
          <tr> 
            <td class='star' align="center" rowspan="2"> 자기신체<br>사고 </td>
            <td colspan="2"> 
              <select name="vins_bacdt_kd" style="width:90px">
                <option value="4">1500만원</option>
                <option value="3">3000만원</option>
                <option value="5">5000만원</option>		
                <option value='6' >1억원</option>					  																						
                <option value="2">1억5천만원</option>
                <option value="1">3억원</option>
              </select>
              &nbsp;(1인당사망/장해) 
            </td>
            <td align=right rowspan="2"> 
              <input type='text' name="vins_bacdt_amt" value="<%=Util.parseDecimal(vins_bacdt_amt)%>" size='9' class='num' onBlur="javascript:this.value=parseDecimal(this.value); ChangeAmt()">
              원</td>
          </tr>
          <tr> 
            <td colspan="2"> 
              <select name="vins_bacdt_kc2" style="width:90px">
                <option value="4" selected>1500만원</option>
                <option value="3">3000만원</option>
                <option value="5">5000만원</option>	
                <option value='6' >1억원</option>					  																											
                <option value="2">1억5천만원</option>
                <option value="1">3억원</option>
              </select>
              &nbsp;(1인당부상) 
            </td>
          </tr>
          <tr> 
            <td class='star' align="center"> 아마존카<br>보험</td>
            <td colspan="2">(자차면책금)</td>
            <td align=right> 
              <input type='text' name="vins_cacdt_amt" value="<%=Util.parseDecimal(imm_amt)%>" size='9' class='num' readonly>
              원</td>
          </tr>
          <tr> 
            <td class='star' align="center"> 무보험차<br>상해 </td>
            <td colspan="2">&nbsp;</td>
            <td align="right"> 
              <input type='text' name="vins_canoisr_amt" value="<%=Util.parseDecimal(vins_canoisr_amt)%>" size='9' class='num' onBlur="javascript:this.value=parseDecimal(this.value); ChangeAmt()" >
              원</td>
          </tr>
          <tr> 
            <td class='star' rowspan="2" align="center"> 자기차량<br>손해 </td>
            <td width="100">차량</td>
            <td width="120"> 
              <input type='text' name="vins_cacdt_car_amt" value="<%=Util.parseDecimal(vins_cacdt_car_amt)%>" size='8' class='num' onBlur="javascript:this.value=parseDecimal(this.value); ChangeAmt()" >
              만원</td>
            <td align="right" rowspan="2"> 
              <input type='text' name="vins_cacdt_cm_amt" value="<%=Util.parseDecimal(vins_cacdt_cm_amt)%>" size='9' class='num' onBlur="javascript:this.value=parseDecimal(this.value); ChangeAmt()">
              원 </td>
          </tr>
          <tr> 
            <td> 자기부담금 </td>
            <td> 
              <input type='text' name="vins_cacdt_me_amt" value="<%=Util.parseDecimal(vins_cacdt_me_amt)%>" size='8' class='num' onBlur="javascript:this.value=parseDecimal(this.value); ChangeAmt()">
              만원</td>
          </tr>
          <tr> 
            <td class='star' align="center"> 특약</td>
            <td colspan="2"> 
              <input type='text' name="vins_spe" value="<%=vins_spe%>" size='30'  class='text' >
            </td>
            <td align=right> 
              <input type='text' name="vins_spe_amt" value="<%=Util.parseDecimal(vins_spe_amt)%>" size='9' class='num' onBlur="javascript:this.value=parseDecimal(this.value); ChangeAmt()">
              원</td>
          </tr>
          <tr> 
            <td class='star' align="center"> 합계 </td>
            <td colspan="2"></td>
            <td align=right> 
              <input type='text' name="vins_tot_amt" value="<%=Util.parseDecimal(vins_tot_amt)%>" size='9' class='num' readonly>
              원</td>
          </tr>
          <tr> 
            <td class='title'> 납부<br>
              횟수 </td>
            <td>&nbsp; 
              <%if(cmd.equals("id")){%>
              <select name="pay_tm" onChange="javascript:ChangeSche();">
                <option value="">-</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="6">6</option>
              </select>
              회 
              <%}else{%>
              <select name="pay_tm" onChange="javascript:ChangeSche();" >
                <option value="">-</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="6">6</option>
              </select>
              회 
			  <script>
					document.InsurForm.pay_tm.value = '<%=ins_scd_size%>';			  
			  </script>
              <%}%>
            </td>
            <td align="right" colspan="2">합계&nbsp;&nbsp;</td>
            <td align=right> 
              <input type='text' name="tot_amt" value="<%=Util.parseDecimal(tot_amt)%>" class='num' size='9' readonly>
              원</td>
          </tr>
        </table>
	  </td>		
      <td align='left' width='30'></td>
	  <td valign=top>
	    <table border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class=line>
			  <table border="0" cellspacing="1" cellpadding="0" width=360>
				<tr>
				  <td width=50 class='title'>회차</td>
				  <td width=80 class='title'>납부예정일</td>
				  <td width=150 class='title'>납부금액</td>
				  <td width=80 class='title'>납부일</td>
				</tr>
				<%	for(int i = 0 ; i < ins_scd_size ; i++){
						InsurScdBean scd = (InsurScdBean)ins_scd.elementAt(i);%>
				<tr id="insuSche<%=i+1%>" >
				  <td align=center><%= scd.getIns_tm() %><input type="hidden" name="ins_tm<%=i%>" value="<%= scd.getIns_tm() %>"></td>
				  <td align=center><input type='text' name="ins_est_dt<%=i%>" value="<%= scd.getIns_est_dt() %>" size='10' class='text'></td>
				  <td align=center><input type='text' name="pay_amt<%=i%>" value="<%= scd.getPay_amt() %>" size='19' class='num'>&nbsp;원</td>
				  <td align=center><input type='text' name="pay_dt<%=i%>" value="<%= scd.getPay_dt() %>" size='10' class='text'></td>
				</tr>
				<%	}%>
				<%	for(int i=ins_scd_size; i<7-ins_scd_size; i++){%>
				<tr id="insuSche<%=i+1%>" style='display:none'>
				  <td align=center><%=i+1%><input type="hidden" name="ins_tm<%=i%>" value="<%=i+1%>"></td>
				  <td align=center><input type='text' name="ins_est_dt<%=i%>" value="" size='10' class='text' onBlur="javascript:AddDate('<%=i+1%>')"></td>
				  <td align=center><input type='text' name="pay_amt<%=i%>" value="" size='19'  class='num' onBlur="javascript:ChangeIns('<%=i+1%>')">&nbsp;원</td>
				  <td align=center><input type='text' name="pay_dt<%=i%>" value="" size='10' class='text'></td>
				</tr>
				<%	}%>				
			  </table>
			</td>
		  </tr>
		</table>		
	  </td>
	</tr>
	<tr>
	  <td align='left' colspan=3>	<<기타사항>>></td>
	</tr>
	<tr>
	  <td class='line' colspan=3>
		<table border="0" cellspacing="1" cellpadding="0" width=800>
		  <tr>
			<td class='title'> 가입경력율</td>
			<td align="center"><input type='text' name="car_rate" value="<%=car_rate%>" size='14' class='text'></td>
			<td class='title'>보험율</td>
			<td align="center"><input type='text' name="ins_rate" value="<%=ins_rate%>" size='14' class='text'></td>
			<td class='title'>할인할증율</td>
			<td align="center" colspan=3><input type='text' name="ext_rate" value="<%=ext_rate%>" size='47' class='text'></td>					
		  </tr>
		  <tr>
			<td width="100" class='title' > 담당자	</td>
			<td width="100" align="center"><input type='text' name="agnt_nm" value="<%=agnt_nm%>" size='14' class='text'></td>
			<td width="100" class='title' > 전화번호	</td>
			<td width="100" align="center"><input type='text' name="agnt_tel" value="<%=agnt_tel%>" size='14' class='text'></td>
			<td width="100" class='title' > 긴급전화번호	</td>
			<td width="100" align="center"><input type='text' name="agnt_imgn_tel" value="<%=agnt_imgn_tel%>" size='14' class='text'></td>
			<td width="100" class='title' > 팩스	</td>
			<td width="100" align="center"><input type='text' name="agnt_fax" value="<%=agnt_fax%>" size='14' class='text'></td>
		  </tr>
		  <tr>
			<td class='title'> 에어백 </td>
			<td colspan='9'> 
			  <input type='radio' name='rdo_air' value="1" onClick="javascript:document.InsurForm.air_ds_yn.checked =true" <% if(air_ds_yn.equals("Y")||air_as_yn.equals("Y")) out.println("checked"); %>>유 
			  (<input type='checkbox' name="air_ds_yn" value="Y" <% if(air_ds_yn.equals("Y")) out.println("checked"); %>> 운전석
			  <input type='checkbox' name="air_as_yn" value="Y"<% if(air_as_yn.equals("Y")) out.println("checked"); %>> 조수석)
			  <input type='radio' name='rdo_air' value="2" onClick="javascript:document.InsurForm.air_ds_yn.checked =false; document.InsurForm.air_as_yn.checked =false;" <% if(!(air_ds_yn.equals("Y")||air_as_yn.equals("Y"))) out.println("checked"); %>>무  
			</td>
		  </tr>			
		</table>
	  </td>
	</tr>
	<tr>
	  <td align='right' colspan=3>
	  <%	if(cmd.equals("id"))	{%>				
		<a href="javascript:self.close();window.close();">닫기</a>&nbsp;|&nbsp;<a href="javascript:InsurReg()">등록</a>
	  <% 	}else{%>
		<a href="javascript:self.close();window.close();">닫기</a>&nbsp;|&nbsp;<a href="javascript:InsurReg()">수정</a>
	  <%}%>	
	  </td>
	</tr>
  </table>
<%	}%>
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<input type="hidden" name="rent_mng_id" value="<%= rent_mng_id %>">
<input type="hidden" name="rent_l_cd" value="<%= rent_l_cd %>">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
</form>
<script language="JavaScript">
<!--
//	document.InsurForm.age_scp.value = '<%=age_scp%>';
//	document.InsurForm.car_use.value = '<%=car_use%>';		
	document.InsurForm.vins_pcp_kd.value = '<%=vins_pcp_kd%>';		
	document.InsurForm.vins_gcp_kd.value = '<%=vins_gcp_kd%>';	
	document.InsurForm.vins_bacdt_kd.value = '<%=vins_bacdt_kd%>';
	document.InsurForm.vins_bacdt_kc2.value = '<%=vins_bacdt_kc2%>';	
		
<%	if(cmd.equals("u")){
		if(count==1){%>
		alert("정상적으로 수정되었습니다.");
<%		}
	}else{
		if(count==1){%>
		alert("정상적으로 등록되었습니다.");
<%		}
	}%>
//-->
</script>
<iframe src="./i_null.jsp" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
