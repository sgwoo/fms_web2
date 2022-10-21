<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"ins_s_frame.jsp":request.getParameter("go_url");
	if(go_url.equals(""))	go_url = "ins_s_frame.jsp";
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//보험관리번호
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String mode = "0";
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	if(gubun.equals("cls"))	go_url = "../con_ins_cls/ins_cls_frame.jsp";
	
	String accid_st = request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	int count = 0;
	int flag = 0;
	
	//보험정보
	InsurBean ins = ai_db.getInsCase(c_id, ins_st);
		
	//보험기간비용
	Vector costs = ai_db.getPrecosts(c_id, ins_st, "2");
	int cost_size = costs.size();
	
	out.println("기간비용 "+cost_size+"건<br>");
	
	String cost_dt		= "";
	String car_no		= "";
	String car_use		= "";
	int use_amt = 0;
	int rest_amt = 0;
	int rest_day = 0;
	int cost_day = 0;
	
	for(int j = 0 ; j < 13 ; j++){
		out.println(j);
		if((j+1) < cost_size){
			Hashtable ht = (Hashtable)costs.elementAt(j);
			out.println(String.valueOf(ht.get("COST_TM")));
			//insert
			out.println("변화없음");
			use_amt = AddUtil.parseInt(String.valueOf(ht.get("COST_AMT")));
			rest_amt = AddUtil.parseInt(String.valueOf(ht.get("REST_AMT")));
			rest_day = AddUtil.parseInt(String.valueOf(ht.get("REST_DAY")));
			cost_day = AddUtil.parseInt(String.valueOf(ht.get("COST_DAY")));
			car_no = String.valueOf(ht.get("CAR_NO"));
			car_use = String.valueOf(ht.get("CAR_USE"));
		}else{
			//해지스케줄 반영된 마지막회차 update
			if((j+1)==cost_size){
				Hashtable ht = (Hashtable)costs.elementAt(j);
				out.println(String.valueOf(ht.get("COST_TM")));
				out.println(String.valueOf(ht.get("COST_YM")));
				out.println("해지스케줄 반영된 마지막회차 update");	
				cost_day = AddUtil.parseInt(String.valueOf(ht.get("COST_DAY")));
				cost_dt = String.valueOf(ht.get("COST_YM"));
				rest_amt= rest_amt-use_amt;				
				PrecostBean cost = ai_db.getInsurPrecostCase("2",c_id,ins_st,cost_dt);
				rest_day= rest_day-cost_day;
				cost.setCost_amt	(use_amt);
				cost.setRest_day	(rest_day);
				cost.setRest_amt	(rest_amt);				
				if(!ai_db.updatePrecost(cost)) flag += 1;
			//insert
			}else{
				cost_dt = AddUtil.replace(c_db.addMonth(ins.getIns_start_dt(), j),"-","");
				if(rest_day <30){
					cost_day = rest_day;
				}
				rest_day= rest_day-cost_day;
				if(use_amt > rest_amt){
					use_amt = rest_amt;
				}
				rest_amt= rest_amt-use_amt;
				PrecostBean cost = new PrecostBean();				
				cost.setCar_mng_id	(c_id);
				cost.setCost_id		(ins_st);
				cost.setCost_st		("2");
				cost.setCost_tm		(String.valueOf(j+1));
				cost.setCost_ym     (cost_dt.substring(0,6));				
				cost.setCost_day	(30);
				cost.setCost_amt	(use_amt);
				cost.setRest_day	(rest_day);
				cost.setRest_amt	(rest_amt);
				cost.setUpdate_id	(user_id);
				cost.setCar_no		(car_no);
				cost.setCar_use		(car_use);
				if(!ai_db.insertPrecost(cost)) flag += 1;
				out.println(cost.getCost_tm());
				out.println(cost_dt);
				out.println("insert");
			}
			
		}		
		out.println(cost_day);
		out.println(use_amt);		
		out.println(rest_amt);
		out.println(rest_day);
		out.println("<br>");
	}
	
	out.println("<br>");
	
	
	//보험해지스케줄
	Vector ins_scd = ai_db.getInsScds(c_id, ins_st);
	int ins_scd_size = ins_scd.size();	
	for(int i = 0 ; i < ins_scd_size ; i++){
		InsurScdBean scd = (InsurScdBean)ins_scd.elementAt(i);
		if(scd.getIns_tm2().equals("2")){			
			if(!ai_db.dropInsScd(c_id, ins_st, scd.getIns_tm())) flag += 1;
		}
	}	
	
	
	//보험해지삭제
	if(!ai_db.dropInsCls(c_id, ins_st)) flag += 1;
		
	//보험상태 수정
	ins.setIns_sts		("1");	//1:유효, 2:만료, 3:중도해지, 4:오프리스보험
	if(!ai_db.updateIns(ins))	flag += 1;
	
	
	out.println("보험해지 취소!!");
	if(1==1)return;
%>

<form name='form1' method='post' action='ins_u_frame.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type='hidden' name="go_url" value='<%=go_url%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="ins_st" value='<%=ins_st%>'>
<input type='hidden' name="mode" value='<%=mode%>'>
<input type='hidden' name="cmd" value='<%=cmd%>'>
</form>
<script language='javascript'>
<%	if(count == 1){	%>
		alert('보험삭제 에러입니다.\n\n삭제되지 않았습니다');
		location='about:blank';
<%	}else{	%>
		alert("삭제되었습니다");
		var fm = document.form1;
		fm.action = "ins_s_frame.jsp";		
		fm.target = "d_content";		
		fm.submit();				
<%	}	%>
</script>
</body>
</html>
