<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  	==null?"":request.getParameter("br_id");

	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String s_dt 	= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 	= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun1="+gubun1+"&gubun2="+gubun2+"&s_dt="+s_dt+"&e_dt="+e_dt+
				   	"&sh_height="+sh_height+"";
				   	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	int s_total1 = 0;	
	int s_total2 = 0;	
	int s_total3 = 0;	
	int s_total4 = 0;	
	int s_total5 = 0;	
	int s_total6 = 0;	
	int s_total7 = 0;	
	int s_total8 = 0;	
	int s_total9 = 0;	
	int s_total10 = 0;	
	int s_total11 = 0;	
	int s_total12 = 0;	

	int d_total3 = 0;	
	int d_total4 = 0;	
	int d_total11 = 0;
	int d_total12 = 0;


	String comm_rt_nm[] = new String[4];
	comm_rt_nm[0] = "0%";
	comm_rt_nm[1] = "1%이하";
	comm_rt_nm[2] = "2%이하";
	comm_rt_nm[3] = "3%이하";
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function open_comm_rt(bus_st, dlv_st, car_st, comm_r_rt){
		var SUBWIN="/acar/car_office/rent_comm_rt_list.jsp?dlv_st="+dlv_st+"&car_st="+car_st+"&bus_st="+bus_st+"&comm_r_rt="+comm_r_rt+"&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>";	
		window.open(SUBWIN, "CommRt"+car_st, "left=10, top=10, width=1000, height=800, scrollbars=yes");
	}
//-->
</script>
</head>
<body>
<form name='form1' method='post' target='d_content' action=''>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
  <input type='hidden' name='s_dt' value='<%=s_dt%>'>
  <input type='hidden' name='e_dt' value='<%=e_dt%>'>
<table border=0 cellspacing=0 cellpadding=0 width=900>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line' width='100%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='14%' class='title'>영업구분</td>
		    <td width='14%' class='title'>출고구분</td>
		    <td width='14%' class='title'>용도구분</td>		    
		    <td width='14%' class='title'>적용수수료율</td>
		    <td width='14%' class='title'>건수</td>
		    <td width='15%' class='title'>비율</td>
		    <td width='15%' class='title'>출고보전수당</td>
		</tr>    
		<!--영업사원영업/영업사원출고/렌트-->
		<%	Hashtable ht1 = umd.getRentCommRtStat_2019("stat", "1", "N", "1", gubun1, gubun2, s_dt, e_dt);
			for(int j = 0 ; j < 4 ; j++){	
				s_total1 	+= AddUtil.parseInt(String.valueOf(ht1.get("CNT"+j)));
		%>
		<tr>
		    <%if(j==0){%><td align='center' rowspan=23>영업사원영업</td><%}%>
		    <%if(j==0){%><td align='center' rowspan=11>영업사원출고</td><%}%>
		    <%if(j==0){%><td align='center' rowspan=5>렌트</td><%}%>
		    <td align='center'><%=comm_rt_nm[j]%></td>
		    <td align='center'><a href="javascript:open_comm_rt('1','N','1','<%=j%>')"><%=ht1.get("CNT"+j)%></a></td>
		    <td align='center'><%=ht1.get("PER"+j)%>%</td>
		    <td align='center'></td>
		</tr>  
		<%	}%>
		<tr>		    
		    <td align='center' class='is'>소계</td>		    
		    <td align='center' class='is'><%=s_total1%></td>
		    <td align='center' class='is'>-</td>
		    <td align='center' class='is'>-</td>		    
		</tr>  					  		
		<!--영업사원영업/영업사원출고/리스-->
		<%	Hashtable ht2 = umd.getRentCommRtStat_2019("stat", "1", "N", "3", gubun1, gubun2, s_dt, e_dt);
			for(int j = 0 ; j < 4 ; j++){	
				s_total2 	+= AddUtil.parseInt(String.valueOf(ht2.get("CNT"+j)));
		%>
		<tr>
		    <%if(j==0){%><td align='center' rowspan=5>리스</td><%}%>
		    <td align='center'><%=comm_rt_nm[j]%></td>
		    <td align='center'><a href="javascript:open_comm_rt('1','N','3','<%=j%>')"><%=ht2.get("CNT"+j)%></a></td>
		    <td align='center'><%=ht2.get("PER"+j)%>%</td>
		    <td align='center'></td>
		</tr>  
		<%	}%>
		<tr>		    
		    <td align='center' class='is'>소계</td>		    
		    <td align='center' class='is'><%=s_total2%></td>
		    <td align='center' class='is'>-</td>
		    <td align='center' class='is'>-</td>		    
		</tr>  					  							   		
		<tr>		    
		    <td align='center' class='title' colspan='2'>합계</td>
		    <td align='center' class='title'><%=s_total1+s_total2%></td>
		    <td align='center' class='title'>-</td>
		    <td align='center' class='title'>-</td>
		</tr> 
		<!--영업사원영업/자체출고/렌트-->
		<%	Hashtable ht3 = umd.getRentCommRtStat_2019("stat", "1", "Y", "1", gubun1, gubun2, s_dt, e_dt);
			for(int j = 0 ; j < 4 ; j++){	
				s_total3 	+= AddUtil.parseInt(String.valueOf(ht3.get("CNT"+j)));
				d_total3 	+= AddUtil.parseInt(String.valueOf(ht3.get("D_CNT"+j)));
		%>
		<tr>		    
		    <%if(j==0){%><td align='center' rowspan=11>자체출고</td><%}%>
		    <%if(j==0){%><td align='center' rowspan=5>렌트</td><%}%>
		    <td align='center'><%=comm_rt_nm[j]%></td>
		    <td align='center'><a href="javascript:open_comm_rt('1','Y','1','<%=j%>')"><%=ht3.get("CNT"+j)%></a></td>
		    <td align='center'><%=ht3.get("PER"+j)%>%</td>
		    <td align='center'><%=ht3.get("D_CNT"+j)%></td>
		</tr>  
		<%	}%>
		<tr>		    
		    <td align='center' class='is'>소계</td>		    
		    <td align='center' class='is'><%=s_total3%></td>
		    <td align='center' class='is'>-</td>
		    <td align='center' class='is'><%=d_total3%></td>		    
		</tr>  					  		
		<!--영업사원영업/자체출고/리스-->
		<%	Hashtable ht4 = umd.getRentCommRtStat_2019("stat", "1", "Y", "3", gubun1, gubun2, s_dt, e_dt);
			for(int j = 0 ; j < 4 ; j++){	
				s_total4 	+= AddUtil.parseInt(String.valueOf(ht4.get("CNT"+j)));
				d_total4 	+= AddUtil.parseInt(String.valueOf(ht4.get("D_CNT"+j)));
		%>
		<tr>
		    <%if(j==0){%><td align='center' rowspan=5>리스</td><%}%>
		    <td align='center'><%=comm_rt_nm[j]%></td>
		    <td align='center'><a href="javascript:open_comm_rt('1','Y','3','<%=j%>')"><%=ht4.get("CNT"+j)%></a></td>
		    <td align='center'><%=ht4.get("PER"+j)%>%</td>
		    <td align='center'><%=ht4.get("D_CNT"+j)%></td>
		</tr>  
		<%	}%>
		<tr>		    
		    <td align='center' class='is'>소계</td>		    
		    <td align='center' class='is'><%=s_total4%></td>
		    <td align='center' class='is'>-</td>
		    <td align='center' class='is'><%=d_total4%></td>		    
		</tr>  					  							   		
		<tr>		    
		    <td align='center' class='title' colspan='2'>합계</td>
		    <td align='center' class='title'><%=s_total3+s_total4%></td>
		    <td align='center' class='title'>-</td>
		    <td align='center' class='title'><%=d_total3+d_total4%></td>
		</tr> 		
		<tr>		    
		    <td align='center' class='title' colspan='3'>합계</td>
		    <td align='center' class='title'><%=s_total1+s_total2+s_total3+s_total4%></td>
		    <td align='center' class='title'>-</td>
		    <td align='center' class='title'>-</td>
		</tr> 		
		
		<!--에이전트영업/영업사원출고/렌트-->
		<%	Hashtable ht9 = umd.getRentCommRtStat_2019("stat", "2", "N", "1", gubun1, gubun2, s_dt, e_dt);
			for(int j = 0 ; j < 4 ; j++){	
				s_total9 	+= AddUtil.parseInt(String.valueOf(ht9.get("CNT"+j)));
		%>
		<tr>
		    <%if(j==0){%><td align='center' rowspan=23>에이전트영업</td><%}%>
		    <%if(j==0){%><td align='center' rowspan=11>영업사원출고</td><%}%>
		    <%if(j==0){%><td align='center' rowspan=5>렌트</td><%}%>
		    <td align='center'><%=comm_rt_nm[j]%></td>
		    <td align='center'><a href="javascript:open_comm_rt('2','N','1','<%=j%>')"><%=ht9.get("CNT"+j)%></a></td>
		    <td align='center'><%=ht9.get("PER"+j)%>%</td>
		    <td align='center'></td>
		</tr>  
		<%	}%>
		<tr>		    
		    <td align='center' class='is'>소계</td>		    
		    <td align='center' class='is'><%=s_total9%></td>
		    <td align='center' class='is'>-</td>
		    <td align='center' class='is'>-</td>		    
		</tr>  					  		
		<!--에이전트영업/영업사원출고/리스-->
		<%	Hashtable ht10 = umd.getRentCommRtStat_2019("stat", "2", "N", "3", gubun1, gubun2, s_dt, e_dt);
			for(int j = 0 ; j < 4 ; j++){	
				s_total10 	+= AddUtil.parseInt(String.valueOf(ht10.get("CNT"+j)));
		%>
		<tr>
		    <%if(j==0){%><td align='center' rowspan=5>리스</td><%}%>
		    <td align='center'><%=comm_rt_nm[j]%></td>
		    <td align='center'><a href="javascript:open_comm_rt('2','N','3','<%=j%>')"><%=ht10.get("CNT"+j)%></a></td>
		    <td align='center'><%=ht10.get("PER"+j)%>%</td>
		    <td align='center'></td>
		</tr>  
		<%	}%>
		<tr>		    
		    <td align='center' class='is'>소계</td>		    
		    <td align='center' class='is'><%=s_total10%></td>
		    <td align='center' class='is'>-</td>
		    <td align='center' class='is'>-</td>		    
		</tr>  					  							   		
		<tr>		    
		    <td align='center' class='title' colspan='2'>합계</td>
		    <td align='center' class='title'><%=s_total9+s_total10%></td>
		    <td align='center' class='title'>-</td>
		    <td align='center' class='title'>-</td>
		</tr> 
		<!--에이전트영업/자체출고/렌트-->
		<%	Hashtable ht11 = umd.getRentCommRtStat_2019("stat", "2", "Y", "1", gubun1, gubun2, s_dt, e_dt);
			for(int j = 0 ; j < 4 ; j++){	
				s_total11 	+= AddUtil.parseInt(String.valueOf(ht11.get("CNT"+j)));
				d_total11 	+= AddUtil.parseInt(String.valueOf(ht11.get("D_CNT"+j)));
		%>
		<tr>		    
		    <%if(j==0){%><td align='center' rowspan=11>자체출고</td><%}%>
		    <%if(j==0){%><td align='center' rowspan=5>렌트</td><%}%>
		    <td align='center'><%=comm_rt_nm[j]%></td>
		    <td align='center'><a href="javascript:open_comm_rt('2','Y','1','<%=j%>')"><%=ht11.get("CNT"+j)%></a></td>
		    <td align='center'><%=ht11.get("PER"+j)%>%</td>
		    <td align='center'><%=ht11.get("D_CNT"+j)%></td>
		</tr>  
		<%	}%>
		<tr>		    
		    <td align='center' class='is'>소계</td>		    
		    <td align='center' class='is'><%=s_total11%></td>
		    <td align='center' class='is'>-</td>
		    <td align='center' class='is'><%=d_total11%></td>		    
		</tr>  					  		
		<!--에이전트영업/자체출고/리스-->
		<%	Hashtable ht12 = umd.getRentCommRtStat_2019("stat", "2", "Y", "3", gubun1, gubun2, s_dt, e_dt);
			for(int j = 0 ; j < 4 ; j++){	
				s_total12 	+= AddUtil.parseInt(String.valueOf(ht12.get("CNT"+j)));
				d_total12 	+= AddUtil.parseInt(String.valueOf(ht12.get("D_CNT"+j)));
		%>
		<tr>
		    <%if(j==0){%><td align='center' rowspan=5>리스</td><%}%>
		    <td align='center'><%=comm_rt_nm[j]%></td>
		    <td align='center'><a href="javascript:open_comm_rt('2','Y','3','<%=j%>')"><%=ht12.get("CNT"+j)%></a></td>
		    <td align='center'><%=ht12.get("PER"+j)%>%</td>
		    <td align='center'><%=ht12.get("D_CNT"+j)%></td>
		</tr>  
		<%	}%>
		<tr>		    
		    <td align='center' class='is'>소계</td>		    
		    <td align='center' class='is'><%=s_total12%></td>
		    <td align='center' class='is'>-</td>
		    <td align='center' class='is'><%=d_total12%></td>		    
		</tr>  					  							   		
		<tr>		    
		    <td align='center' class='title' colspan='2'>합계</td>
		    <td align='center' class='title'><%=s_total11+s_total12%></td>
		    <td align='center' class='title'>-</td>
		    <td align='center' class='title'><%=d_total11+d_total12%></td>
		</tr> 		
		<tr>		    
		    <td align='center' class='title' colspan='3'>합계</td>
		    <td align='center' class='title'><%=s_total9+s_total10+s_total11+s_total12%></td>
		    <td align='center' class='title'>-</td>
		    <td align='center' class='title'>-</td>
		</tr> 				


		<!--자체영업/영업사원출고/렌트-->
		<%	Hashtable ht5 = umd.getRentCommRtStat_2019("stat", "3", "N", "1", gubun1, gubun2, s_dt, e_dt);
			s_total5 = AddUtil.parseInt(String.valueOf(ht5.get("CNT")));
		%>
		<tr>
		    <td align='center' rowspan=7>자체영업</td>
		    <td align='center' rowspan=3>영업사원출고</td>
		    <td align='center'>렌트</td>
		    <td align='center'>-</td>
		    <td align='center'><a href="javascript:open_comm_rt('3','N','1','')"><%=s_total5%></a></td>
		    <td align='center'></td>
		    <td align='center'></td>
		</tr>  
		<!--자체영업/영업사원출고/리스-->
		<%	Hashtable ht6 = umd.getRentCommRtStat_2019("stat", "3", "N", "3", gubun1, gubun2, s_dt, e_dt);
			s_total6 = AddUtil.parseInt(String.valueOf(ht6.get("CNT")));			
		%>
		<tr>
		    <td align='center'>리스</td>
		    <td align='center'>-</td>
		    <td align='center'><a href="javascript:open_comm_rt('3','N','3','')"><%=s_total6%></a></td>
		    <td align='center'></td>
		    <td align='center'></td>
		</tr>  		
		
		<tr>		    
		    <td align='center' class='title' colspan='2'>합계</td>			    
		    <td align='center' class='title'><%=s_total5+s_total6%></td>
		    <td align='center' class='title'>-</td>
		    <td align='center' class='title'>-</td>		    
		</tr>  	
		
		<!--자체영업/자체출고/렌트-->
		<%	Hashtable ht7 = umd.getRentCommRtStat_2019("stat", "3", "Y", "1", gubun1, gubun2, s_dt, e_dt);
			s_total7 = AddUtil.parseInt(String.valueOf(ht7.get("CNT")));			
		%>
		<tr>		    
		    <td align='center' rowspan=3>자체출고</td>
		    <td align='center'>렌트</td>
		    <td align='center'>-</td>
		    <td align='center'><a href="javascript:open_comm_rt('3','Y','1','')"><%=s_total7%></a></td>
		    <td align='center'></td>
		    <td align='center'></td>
		</tr>  
		<!--자체영업/자체출고/리스-->
		<%	Hashtable ht8 = umd.getRentCommRtStat_2019("stat", "3", "Y", "3", gubun1, gubun2, s_dt, e_dt);
			s_total8 = AddUtil.parseInt(String.valueOf(ht8.get("CNT")));			
		%>
		<tr>
		    <td align='center'>리스</td>
		    <td align='center'>-</td>
		    <td align='center'><a href="javascript:open_comm_rt('3','Y','3','')"><%=s_total8%></a></td>
		    <td align='center'></td>
		    <td align='center'></td>
		</tr>  		
		
		<tr>		    
		    <td align='center' class='title' colspan='2'>합계</td>			    
		    <td align='center' class='title'><%=s_total7+s_total8%></td>
		    <td align='center' class='title'>-</td>
		    <td align='center' class='title'>-</td>		    
		</tr>  		
		<tr>		    
		    <td align='center' class='title' colspan='3'>합계</td>	
		    <td align='center' class='title'><%=s_total5+s_total6+s_total7+s_total8%></td>
		    <td align='center' class='title'>-</td>
		    <td align='center' class='title'>-</td>		    
		</tr>  		
		<tr>		    
		    <td align='center' class='title' colspan='4'>합계</td>	
		    <td align='center' class='title'><%=s_total1+s_total2+s_total3+s_total4+s_total5+s_total6+s_total7+s_total8+s_total9+s_total10+s_total11+s_total12%></td>
		    <td align='center' class='title'>-</td>
		    <td align='center' class='title'>-</td>		    
		</tr>  										  					
	    </table>
	</td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>