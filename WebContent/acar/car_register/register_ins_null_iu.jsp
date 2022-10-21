<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.cont.*, acar.con_ins.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head><title>FMS</title></head>
<%
	String filename = "";
	/* multipart/form-data 로 FileUpload객체 생성 */ 
	FileUpload file = new FileUpload("C:\\Inetpub\\wwwroot\\data\\ins\\", request.getInputStream());
	filename = file.getFilename() == null ? "" : file.getFilename();//견적서스캔

	
	String auth_rw = file.getParameter("auth_rw")==null?"":file.getParameter("auth_rw");
	String rent_mng_id = file.getParameter("rent_mng_id")==null?"":file.getParameter("rent_mng_id");
	String rent_l_cd = file.getParameter("rent_l_cd")==null?"":file.getParameter("rent_l_cd");
	String car_mng_id = file.getParameter("car_mng_id")==null?"":file.getParameter("car_mng_id");
	String car_no = file.getParameter("car_no")==null?"":file.getParameter("car_no");
	String rpt_no = file.getParameter("rpt_no")==null?"":file.getParameter("rpt_no");
	String firm_nm = file.getParameter("firm_nm")==null?"":file.getParameter("firm_nm");
	String client_nm = file.getParameter("client_nm")==null?"":file.getParameter("client_nm");
	String car_name = file.getParameter("car_name")==null?"":file.getParameter("car_name");
	String cmd = file.getParameter("cmd")==null?"":file.getParameter("cmd");
	String ins_st = file.getParameter("ins_st")==null?"":file.getParameter("ins_st");
	int imm_amt = file.getParameter("imm_amt")==null?0:Util.parseInt(file.getParameter("imm_amt"));
	int count = 0;
	int flag = 0;
	
	//견적서스캔
	String old_scan = file.getParameter("scan") == null ? "" : file.getParameter("scan");//기존스캔
	String new_scan = filename;
	if(!new_scan.equals("")){
		if(!old_scan.equals("") && !new_scan.equals("")){
			File drop_file = new File("C:\\Inetpub\\wwwroot\\data\\ins\\"+old_scan+".pdf");
			drop_file.delete();
		}
	}else{
		filename = old_scan;
	}
	String scan_del = file.getParameter("scan_del") == null ? "" : file.getParameter("scan_del");//기존파일 삭제 체크
	if(scan_del.equals("1")){
		File drop_file = new File("C:\\Inetpub\\wwwroot\\data\\ins\\"+old_scan+".pdf");
		drop_file.delete();
		filename = "";
	}	
	
	InsurBean ins = new InsurBean();
	
	ins.setCar_mng_id(car_mng_id);
	ins.setIns_st(ins_st);
	ins.setIns_sts("1");	//1:유효, 2:중도해지
	ins.setAge_scp(file.getParameter("age_scp")==null?"":file.getParameter("age_scp"));
	ins.setCar_use(file.getParameter("car_use")==null?"":file.getParameter("car_use"));
	ins.setIns_com_id(file.getParameter("ins_com_id")==null?"":file.getParameter("ins_com_id"));
	ins.setIns_con_no(file.getParameter("ins_con_no")==null?"":file.getParameter("ins_con_no"));
	ins.setConr_nm(file.getParameter("conr_nm")==null?"":file.getParameter("conr_nm"));
	ins.setIns_start_dt(file.getParameter("ins_start_dt")==null?"":file.getParameter("ins_start_dt"));
	ins.setIns_exp_dt(file.getParameter("ins_exp_dt")==null?"":file.getParameter("ins_exp_dt"));
	ins.setRins_pcp_amt(file.getParameter("rins_pcp_amt")==null?0:Util.parseDigit(file.getParameter("rins_pcp_amt")));
	ins.setVins_pcp_kd(file.getParameter("vins_pcp_kd")==null?"":file.getParameter("vins_pcp_kd"));
	ins.setVins_pcp_amt(file.getParameter("vins_pcp_amt")==null?0:Util.parseDigit(file.getParameter("vins_pcp_amt")));
	ins.setVins_gcp_kd(file.getParameter("vins_gcp_kd")==null?"":file.getParameter("vins_gcp_kd"));
	ins.setVins_gcp_amt(file.getParameter("vins_gcp_amt")==null?0:Util.parseDigit(file.getParameter("vins_gcp_amt")));
	ins.setVins_bacdt_kd(file.getParameter("vins_bacdt_kd")==null?"":file.getParameter("vins_bacdt_kd"));
	ins.setVins_bacdt_kc2(file.getParameter("vins_bacdt_kc2")==null?"":file.getParameter("vins_bacdt_kc2"));
	ins.setVins_bacdt_amt(file.getParameter("vins_bacdt_amt")==null?0:Util.parseDigit(file.getParameter("vins_bacdt_amt")));
	ins.setVins_cacdt_amt(file.getParameter("vins_cacdt_amt")==null?0:Util.parseDigit(file.getParameter("vins_cacdt_amt")));
	ins.setVins_canoisr_amt(file.getParameter("vins_canoisr_amt")==null?0:Util.parseDigit(file.getParameter("vins_canoisr_amt")));
	ins.setVins_cacdt_car_amt(file.getParameter("vins_cacdt_car_amt")==null?0:Util.parseDigit(file.getParameter("vins_cacdt_car_amt")));
	ins.setVins_cacdt_me_amt(file.getParameter("vins_cacdt_me_amt")==null?0:Util.parseDigit(file.getParameter("vins_cacdt_me_amt")));
	ins.setVins_cacdt_cm_amt(file.getParameter("vins_cacdt_cm_amt")==null?0:Util.parseDigit(file.getParameter("vins_cacdt_cm_amt")));
	ins.setPay_tm(file.getParameter("pay_tm")==null?"":file.getParameter("pay_tm"));
	ins.setChange_dt(file.getParameter("change_dt")==null?"":file.getParameter("change_dt"));
	ins.setChange_cau(file.getParameter("change_cau")==null?"":file.getParameter("change_cau"));
	ins.setChange_itm_kd1(file.getParameter("change_itm_kd1")==null?"":file.getParameter("change_itm_kd1"));
	ins.setChange_itm_amt1(file.getParameter("change_itm_amt1")==null?0:Util.parseDigit(file.getParameter("change_itm_amt1")));
	ins.setChange_itm_kd2(file.getParameter("change_itm_kd2")==null?"":file.getParameter("change_itm_kd2"));
	ins.setChange_itm_amt2(file.getParameter("change_itm_amt2")==null?0:Util.parseDigit(file.getParameter("change_itm_amt2")));
	ins.setChange_itm_kd3(file.getParameter("change_itm_kd3")==null?"":file.getParameter("change_itm_kd3"));
	ins.setChange_itm_amt3(file.getParameter("change_itm_amt3")==null?0:Util.parseDigit(file.getParameter("change_itm_amt3")));
	ins.setChange_itm_kd4(file.getParameter("change_itm_kd4")==null?"":file.getParameter("change_itm_kd4"));
	ins.setChange_itm_amt4(file.getParameter("change_itm_amt4")==null?0:Util.parseDigit(file.getParameter("change_itm_amt4")));
	ins.setCar_rate(file.getParameter("car_rate")==null?"":file.getParameter("car_rate"));
	ins.setIns_rate(file.getParameter("ins_rate")==null?"":file.getParameter("ins_rate"));
	ins.setExt_rate(file.getParameter("ext_rate")==null?"":file.getParameter("ext_rate"));
	ins.setAir_ds_yn(file.getParameter("air_ds_yn")==null?"N":file.getParameter("air_ds_yn"));
	ins.setAir_as_yn(file.getParameter("air_as_yn")==null?"N":file.getParameter("air_as_yn"));
	ins.setAgnt_nm(file.getParameter("agnt_nm")==null?"":file.getParameter("agnt_nm"));
	ins.setAgnt_tel(file.getParameter("agnt_tel")==null?"":file.getParameter("agnt_tel"));
	ins.setAgnt_imgn_tel(file.getParameter("agnt_imgn_tel")==null?"":file.getParameter("agnt_imgn_tel"));
	ins.setAgnt_fax(file.getParameter("agnt_fax")==null?"":file.getParameter("agnt_fax"));
	ins.setExp_dt(file.getParameter("exp_dt")==null?"":file.getParameter("exp_dt"));
	ins.setExp_cau(file.getParameter("exp_cau")==null?"":file.getParameter("exp_cau"));
	ins.setRtn_amt(file.getParameter("rtn_amt")==null?0:Util.parseDigit(file.getParameter("rtn_amt")));
	ins.setRtn_dt(file.getParameter("rtn_dt")==null?"":file.getParameter("rtn_dt"));
	ins.setExp_cau(file.getParameter("exp_cau")==null?"":file.getParameter("exp_cau"));
	ins.setRtn_amt(file.getParameter("rtn_amt")==null?0:Util.parseDigit(file.getParameter("rtn_amt")));
	ins.setRtn_dt(file.getParameter("rtn_dt")==null?"":file.getParameter("rtn_dt"));
	ins.setCon_f_nm(file.getParameter("con_f_nm")==null?"":file.getParameter("con_f_nm"));
	ins.setAcc_tel(file.getParameter("acc_tel")==null?"":file.getParameter("acc_tel"));
	ins.setAgnt_dept(file.getParameter("agnt_dept")==null?"":file.getParameter("agnt_dept"));
	ins.setVins_spe(file.getParameter("vins_spe")==null?"":file.getParameter("vins_spe"));
	ins.setVins_spe_amt(file.getParameter("vins_spe_amt")==null?0:Util.parseDigit(file.getParameter("vins_spe_amt")));
	ins.setEnable_renew("Y");
	ins.setScan_file(filename);
	ins.setReg_id(file.getParameter("user_id")==null?"":file.getParameter("user_id"));
	
	if(cmd.equals("i")){ //등록
		if(!ai_db.insertIns(ins))	flag += 1;
	}else{//수정
		if(!ai_db.updateIns(ins))	flag += 1;
	}

	//보험료 스케줄 입력
	int ins_scd_size = 0;
	if(cmd.equals("i")){ //등록
		ins_scd_size = Util.parseDigit(file.getParameter("pay_tm"));
	}else{
		ins_scd_size = Util.parseDigit(file.getParameter("ins_scd_size"));
	}
	
	String ins_tm[]		= new String[ins_scd_size];
	String ins_est_dt[]	= new String[ins_scd_size];
	int pay_amt[]	= new int[ins_scd_size];
	String pay_dt[]		= new String[ins_scd_size];
	String pay_yn[]		= new String[ins_scd_size];
	
	for(int i = 0 ; i < ins_scd_size ; i++){
		
		ins_tm[i] = file.getParameter("ins_tm"+i);
		ins_est_dt[i] = file.getParameter("ins_est_dt"+i);
		pay_amt[i] = file.getParameter("pay_amt"+i)==null?0:Util.parseDigit(file.getParameter("pay_amt"+i));
		pay_dt[i] = file.getParameter("pay_dt"+i);
		pay_yn[i] = file.getParameter("pay_yn"+i);
		
		InsurScdBean scd = new InsurScdBean();
		scd.setCar_mng_id(car_mng_id);
		scd.setIns_st(ins_st);
		scd.setIns_tm(ins_tm[i]);
		scd.setIns_est_dt(ins_est_dt[i]);
		scd.setPay_amt(pay_amt[i]);
		if(pay_dt[i].equals("")){
			scd.setPay_yn("0");
		}else{
			scd.setPay_yn("1");
		}
		scd.setPay_dt(pay_dt[i]);
		
		if(cmd.equals("i")){ //등록
			if(!ai_db.insertInsScd(scd)) flag += 1;

		}else{
			if(!ai_db.updateInsScd(scd)) flag += 1;

		}
	}

	//추가보험료 생성
	String add_ins = file.getParameter("add_ins")==null?"":file.getParameter("add_ins");
	if(add_ins.equals("Y")){//추가보험료 세팅한 경우
		InsurScdBean scd = new InsurScdBean();
		scd.setCar_mng_id(car_mng_id);
		scd.setIns_st(ins_st);
		scd.setIns_tm(file.getParameter("c_ins_tm")==null?"":file.getParameter("c_ins_tm"));
		scd.setIns_est_dt(file.getParameter("c_ins_est_dt")==null?"":file.getParameter("c_ins_est_dt"));
		scd.setPay_amt(file.getParameter("c_pay_amt")==null?0:Util.parseDigit(file.getParameter("c_pay_amt")));
		scd.setPay_yn("0");			//default:N(미납)
		scd.setPay_dt(file.getParameter("c_pay_dt")==null?"":file.getParameter("c_pay_dt"));
		
		if(!ai_db.insertInsScd(scd))	flag += 1;

	}
	

%>
<script language="JavaScript">
<!--
	function NullAction()
	{
<%	if(cmd.equals("u")){
		if(flag==0){%>
		alert("정상적으로 수정되었습니다.");
		parent.InsurForm.cmd.value = 'udp';
		parent.window.close();	
//		parent.ReLoadIns();
//		window.location="about:blank";
<%		}
	}else{
		if(flag==0){%>
		alert("정상적으로 등록되었습니다.");
		parent.InsurForm.cmd.value = 'udp';
		parent.window.close();	
//		parent.ReLoadIns();
//		window.location="about:blank";
<%		}
	}%>
	}
//-->
</script>
<body onLoad="javascript:NullAction()">
</html>
