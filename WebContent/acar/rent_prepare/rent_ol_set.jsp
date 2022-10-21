<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*, acar.parking.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="pio_bean" scope="page" class="acar.parking.ParkIOBean"/>
<jsp:useBean id="pbean" scope="page" class="acar.parking.ParkBean"/> 
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"decode(i.use_st, '1','2','2','4','3','3','1'), i.rent_st":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String mode = request.getParameter("mode")==null?"2":request.getParameter("mode");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이	
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String[] pre = request.getParameterValues("pr");
	int pre_size = pre.length;
	String value[] = new String[3];
	String c_id = "";
	String park = "";
	int count = 0;
	int count2 = 0;
	ParkIODatabase piod = ParkIODatabase.getInstance();	
	
	for(int i=0; i < pre_size; i++){
	
		StringTokenizer st = new StringTokenizer(pre[i],"^");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;

		}

		c_id		= value[0];
		park		= value[1].trim();

		//매각결정처리 : 매각예정차량만 처리한다.
		count = rs_db.setCar_off_ls1(c_id, mode);	
	
		if(count >= 1){
		
			if(park.equals("목동주차장")){
				park = "영남주차장";
			}
	
			//park_io 에 매각차량 임시로 데이터 입력
			if(park.equals("영남주차장")  || park.equals("오토크린")  || park.equals("부산지점")  || park.equals("부산조양") || park.equals("부산부경") || park.equals("대전현대") || park.equals("대전지점") || park.equals("대전금호")  || park.equals("명진공업사")  || park.equals("광주지점") || park.equals("대구지점") ){

				String park_id = "";
				if  (park.equals("영남주차장")   ) {
				   	park_id = "1";
				} else if  (park.equals("부산지점")  ) {
				   	park_id = "3";
				} else if  (park.equals("부산조양")  ) {
				   	park_id = "8";
			    } else if  (park.equals("부산부경")  ) {
				   	park_id = "7";
				} else if  (park.equals("대전지점")  ) {
				   	park_id = "4";
				} else if  (park.equals("대전현대")  ) {
				   	park_id = "9";
				} else if  (park.equals("대전금호")  ) {
				   	park_id = "11";
				} else if  (park.equals("명진공업사")  ) {
				   	park_id = "5";
				} else if  (park.equals("오토크린")  ) {
				   	park_id = "10";
				} else if  (park.equals("광주지점")  ) {
				   	park_id = "12";
				} else if  (park.equals("대구지점")  ) {
				   	park_id = "13";
				}
				pio_bean.setCar_mng_id(c_id);
                   
				pio_bean.setPark_id(park_id);
				pio_bean.setReg_id(user_id);
				pio_bean.setIo_gubun("3"); /* 3이면 매각 */
					
				count2 = piod.insertParkIO(pio_bean);
				
				//park_condition매각확정 표시											
				count2 = piod.updateParkConditionAuction(c_id);
				
			}
		}
	}
	

%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<script language="JavaScript">
<!--
//alert(<%=count%>);
<%	if(count >= 1){%>
	alert("수정되었습니다.");
	
	if('<%=from_page%>'=='/acar/rent_prepare/sui_sort_sc.jsp'){
		parent.parent.parent.d_content.location.href = "sui_sort_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&sh_height=<%=sh_height%>";	
	}else{
		if('<%=mode%>'=='end'){
			parent.parent.parent.d_content.location.href = "rent_pr_end_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&sh_height=<%=sh_height%>";
		}else{
			parent.parent.parent.d_content.location.href = "rent_pr_frame_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&sh_height=<%=sh_height%>";
		}	
	}
<%}else{%>
	alert("예비차량은 바로 매각결정처리할 수 없습니다. 예비차량이거나 데이터베이스에 문제가 발생입니다.\n 관리자님께 문의하세요 !");
<%}%>
//-->
</script>
</body>
</html>
