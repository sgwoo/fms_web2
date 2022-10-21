<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_register.*, acar.user_mng.*,  acar.bill_mng.*"%>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title></head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String init_reg_dt 		= request.getParameter("init_reg_dt")==null?"":request.getParameter("init_reg_dt");
	
	String hidden_value = "";
	
	hidden_value = "?auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc;
	
	//int st_alt_amt	= request.getParameter("alt_amt")==null?0:Util.parseDigit(request.getParameter("alt_amt"));
	
	String alt_amt	= request.getParameter("alt_amt")==null?"":request.getParameter("alt_amt");	
						
	boolean flag = true;
	int count =0;
	boolean flag1 = true;
			
	CarRegDatabase cr_db = CarRegDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);	
	//자동전표 발행-네오엠 자동전표 처리
	String autodoc = request.getParameter("autodoc")==null?"N":request.getParameter("autodoc");
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
	String node_code ="S101";  //네오엠 iu 에서는 회계단위:S101	
			
//	System.out.println("차량등록 insert_id = " +  insert_id + ":user_id="+user_id + ":car_no=" + car_no);
		
	AutoDocuBean ad_bean = new AutoDocuBean();
	
	ad_bean.setNode_code(request.getParameter("node_code")==null?"S101":request.getParameter("node_code"));	
	ad_bean.setDept_code(dept_code);
	ad_bean.setVen_code("001281");
	ad_bean.setFirm_nm("영등포구청");
	ad_bean.setItem_name(car_no);
	ad_bean.setAcct_dt(init_reg_dt);
	ad_bean.setCom_name(firm_nm);
	ad_bean.setAcct_cont(alt_amt); //등록관련 전체비용 :^으로 파싱할것 :등록세^취득세^매입공채^증지대^번호판대^수수료^총지출액

	ad_bean.setInsert_id(insert_id);
	count = neoe_db.insertCarRegAutoDocu(ad_bean);
	
	//전표정보 자동차등록에 추가하기
	if(!car_mng_id.equals("")){
		//자동차등록정보
		
		CarRegBean cr_bean = cr_db.getCarRegBean(car_mng_id);
		if(cr_bean.getCar_a_yn().equals("") || cr_bean.getCar_a_yn().equals("0") ){
			cr_bean.setCar_mng_id(car_mng_id);
			cr_bean.setCar_a_yn("1");
			flag1 = cr_db.updateCarAutoDocu(cr_bean);
		}
		
		flag = ex_db.updateGenExp(car_mng_id, init_reg_dt, "reg_pay_dt");
	}
		
%>
<form name='form1' method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="asc" value="<%=asc%>">
</form>

<script language='javascript'>
<%	if(!flag){%>
		alert('자동차등록비용 오류발생!');
		location='about:blank';	
<%	}else if(count == 1){%>
		alert('자동전표 오류발생!');
		location='about:blank';		
<%	}else if(!flag1){%>
		alert('자동전표 수정 오류발생!');
		location='about:blank';	
<%	}else{%>
		alert('처리되었습니다');	
<%	}%>
		var fm = document.form1;
		parent.location='exp_reg_sc.jsp<%=hidden_value%>';
		parent.close();
</script>
</body>
</html>
