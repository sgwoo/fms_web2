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
	
	String v_tint_no  = request.getParameter("v_tint_no")==null?"":request.getParameter("v_tint_no");
	String v_off_id  = request.getParameter("v_off_id")==null?"":request.getParameter("v_off_id");
	
	
	boolean flag1 = true;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
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
			
			//계약별용품
			}else{
				o_sup_est_dt = tint.getSup_dt();
				
				String r_sup_dt 	= sup_dt[i]==null?"":sup_dt[i];
				String r_sup_h 		= sup_h[i]==null?"":sup_h[i];

				tint.setSup_dt		(r_sup_dt+" "+r_sup_h);
				
				tint.setSerial_no	(serial_no[i]==null?"":serial_no[i]);			
				
				if(tint.getTint_amt() == 0 && tint.getTint_st().equals("3") && tint.getTint_yn().equals("Y") && tint.getCom_nm().equals("이노픽스") && (tint.getModel_nm().equals("LX100") || tint.getModel_nm().equals("IX200") || tint.getModel_nm().equals("IX-200"))){
					if(AddUtil.parseInt(r_sup_dt) < 20160201)			tint.setTint_amt(104545);
					else								tint.setTint_amt(92727);
				}						
				
				n_sup_est_dt = tint.getSup_dt();
			
			}
		
			//=====[tint] update=====
			flag1 = t_db.updateCarTint(tint);	
			
			

			
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