<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String maker = request.getParameter("maker")==null?"total":request.getParameter("maker");
	String gubun2 	= request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	
	
	Vector cars = ad_db.getStatMakerCarDt2(maker, gubun2, gubun3, gubun4, st_dt, end_dt);
	int cars_size = cars.size();
	int row_cnt = 0, cnt=0;
	
	//int s_year[]	= new int[22];			//2000년도부터 2015년까지(17)->2020년까지(22)
	
	
	//int start_year 	= 2007;				//표시시작년도	
	int end_year 	= AddUtil.getDate2(1);		//현재년도
	int start_year 	= end_year-10;					//표시시작년도
 	int td_size 	= end_year-start_year+1;	//표시년도갯수
 	int td_width 	= 66/td_size;			//표시년도 사이즈 
 	
 	int s_year[]	= new int[32];
 	
 	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	
	
	function OpenList(client_id, firm_nm){
		var SUBWIN = "stat_mng_client_car_list.jsp";
		window.open(SUBWIN+"?client_id="+client_id+"&firm_nm="+firm_nm, "OpenList", "left=50, top=50, width=950, height=500, scrollbars=yes");
	}
	
-->
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <% 	for(int i=0; i<cars.size(); i++){
        				Hashtable ht = (Hashtable)cars.elementAt(i);
        				
						for(int h = start_year ; h <= end_year ; h++){
	        				s_year[h-start_year] += AddUtil.parseInt((String)ht.get("Y"+h));
						}
        		 %>
                <tr>           
                    <td width="23%" class="title"><%= ht.get("CAR_NM") %></td>
                    <td width="<%=100-23-(td_width*td_size)%>%" align="right"><%= ht.get("TOTAL") %></td>
					<%for(int j = end_year ; j >= start_year ; j--){//현재년도%>
                    <td width="<%=td_width%>%" align="right"><%= ht.get("Y"+j) %></td>					
					<%}%>
                </tr>
                <%	} %>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">


	pfm = parent.form1;
	var s_all = 0;
	
	//합계
	<%for(int i = end_year ; i >= start_year ; i--){//현재년도%>
	pfm.s<%=i%>.value = '<%= s_year[i-start_year] %>';	
	s_all = s_all+<%= s_year[i-start_year] %>;
	<%}%>
	pfm.s_all.value = s_all;	
	
	
</script>
