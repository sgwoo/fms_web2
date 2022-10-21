<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,tax.*"%>
<%@ page import="acar.cont.*, acar.tint.*, acar.user_mng.*, acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
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
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 	= request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String tint_st	 	= request.getParameter("tint_st")==null?"":request.getParameter("tint_st");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag9 = true;
	
	int flag = 0;
		
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);

	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));

	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
		
	//용품	
	TintBean tint 	= new TintBean();	
	

	String tint_yn 	= request.getParameter("tint_yn")==null?"":request.getParameter("tint_yn");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
		
	String o_sup_est_dt = "";
	String n_sup_est_dt = "";
	
	o_sup_est_dt = tint.getSup_est_dt();
	

	//현재자료	
	tint.setClient_id		(base.getClient_id());
	tint.setCar_mng_id	(base.getCar_mng_id());
	tint.setCar_nm			(cm_bean.getCar_nm());		
	tint.setCar_num			(cr_bean.getCar_num());
	tint.setCar_no			(cr_bean.getCar_no());
	if(tint.getCar_num().equals("") && pur.getCar_num().equals("")) 	tint.setCar_num		(pur.getCar_num());		

	tint.setTint_yn		(tint_yn);
	tint.setTint_st		(tint_st);

	
	if(off_id.length()>6){
		tint.setOff_id		(off_id.substring(0,6));
		tint.setOff_nm		(off_id.substring(6));
	}else if(off_id.length()==0){
		tint.setOff_id		("");
		tint.setOff_nm		("");		
	}
		
	if(tint_st.equals("3")){
	
		tint.setModel_st	(request.getParameter("model_st")==null?"":request.getParameter("model_st"));		
		
		if(tint.getModel_st().equals("2"))	tint.setModel_st(request.getParameter("model_st_etc")==null?"":request.getParameter("model_st_etc"));
		
		tint.setChannel_st(request.getParameter("channel_st")==null?"":request.getParameter("channel_st"));		
		
		tint.setModel_id	(request.getParameter("model_id")==null?"":request.getParameter("model_id"));
	}
	
	tint.setEtc		(request.getParameter("etc")==null?"":request.getParameter("etc"));
		
	String r_sup_est_dt 	= request.getParameter("sup_est_dt")==null?"":request.getParameter("sup_est_dt");
	String r_sup_est_h 	= request.getParameter("sup_est_h")==null?"":request.getParameter("sup_est_h");
	tint.setSup_est_dt	(r_sup_est_dt+""+r_sup_est_h);
		
	String r_sup_dt 	= request.getParameter("sup_dt")==null?"":request.getParameter("sup_dt");
	String r_sup_h 		= request.getParameter("sup_h")==null?"":request.getParameter("sup_h");
	tint.setSup_dt		(r_sup_dt+""+r_sup_h);

	tint.setCom_nm			(request.getParameter("com_nm")==null?"":request.getParameter("com_nm"));
	tint.setModel_nm		(request.getParameter("model_nm")==null?"":request.getParameter("model_nm"));
	tint.setCost_st			(request.getParameter("cost_st")==null?"":request.getParameter("cost_st"));
	tint.setEst_st			(request.getParameter("est_st")==null?"":request.getParameter("est_st"));
	tint.setEst_m_amt		(request.getParameter("est_m_amt")==null? 0:AddUtil.parseDigit(request.getParameter("est_m_amt")));
	tint.setTint_su			(1);		
	
	tint.setTint_amt		(request.getParameter("tint_amt")==null? 0:AddUtil.parseDigit(request.getParameter("tint_amt")));
	tint.setSerial_no		(request.getParameter("serial_no")==null?"":request.getParameter("serial_no"));
	
	if(tint_st.equals("3") && !tint.getModel_id().equals("")){
    tint.setTint_amt(92727); 	  																		//공임20000
    if(tint.getOff_id().equals("002849"))	tint.setTint_amt(87727); 	//공임15000
  }
                	
	
	n_sup_est_dt = tint.getSup_est_dt();

	
	tint.setRent_mng_id	(rent_mng_id);
	tint.setRent_l_cd		(rent_l_cd);
	tint.setReg_id			(user_id);
	tint.setReg_st			("A");
			
	//=====[tint] insert=====
	String tint_no = t_db.insertCarTint(tint);


%>


<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>



<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 		value="<%=user_id%>">
  <input type="hidden" name="br_id" 		value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 		value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 	value='<%=from_page%>'>   
  <input type="hidden" name="rent_st" 		value="1">
</form>

<script language='javascript'>

	var fm = document.form1;
	
	alert('등록되었습니다. 협력업체관리-용품관리-용품미수신현황에서 확인하세요.');	
	
	fm.action = '<%=from_page%>';
	fm.target = 'c_foot';
	fm.submit();
	
	parent.window.close();

</script>
</body>
</html>