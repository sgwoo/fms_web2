<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.off_demand.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
	
	String gubun = "";
	String ref_dt1 = String.valueOf(AddUtil.parseInt(save_dt.substring(0,4))-5)+"0101"; //마감기준일-4년전 - 미사용
	String ref_dt2 = save_dt; //마감기준일
	
	//구입
	Vector vt = dm_db.getOffDemandStat10("", ref_dt1,ref_dt2);		
	int vt_size = vt.size();	
	
	int cnt1 = 0;
	int cnt2 = 0;
	int b_cnt = 0;

	int sum_cnt1 = 0;
	int sum_cnt2 = 0;
	int sum_cnt3 = 0;
	
	for(int k=0;k<vt_size;k++){
		Hashtable ht = (Hashtable)vt.elementAt(k);
		if(String.valueOf(ht.get("BR_GUBUN")).equals("본사")){
			cnt1 ++;
			sum_cnt1  = sum_cnt1 + AddUtil.parseInt(String.valueOf(ht.get("CNT")));
				
			if(String.valueOf(ht.get("DEPT_GUBUN")).equals("IT마케팅팀")){
				sum_cnt3  = sum_cnt3 + AddUtil.parseInt(String.valueOf(ht.get("CNT")));
			}
		}
		if(String.valueOf(ht.get("BR_GUBUN")).equals("지점")){
			cnt2 ++;
			sum_cnt2  = sum_cnt2 + AddUtil.parseInt(String.valueOf(ht.get("CNT")));				
		}			
	}			
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='off_demand_sc10.jsp' method='post' target='t_content'>
  <table border="0" cellspacing="0" cellpadding="0" width=1000>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>부서 및 임직원 현황</span></td>
	  </tr>
    <tr>
        <td align=right><%=AddUtil.ChangeDate2(save_dt) %> 현재</td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>	
	<tr>		
								<td class='line'> 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td  class='title' colspan='2'>부서명</td>
										<td  class='title' style="width:100px;height:35px;">상근인원</td>
										<td  class='title' style="width:700px;" >주요업무</td>		  
									</tr>
    					  			<%	
    					  				b_cnt = 0;
										for(int k=0;k<vt_size;k++){
        					  				Hashtable ht = (Hashtable)vt.elementAt(k);
        					  				if(String.valueOf(ht.get("BR_GUBUN")).equals("본사")){       
        					  					b_cnt++;
        							%>
									<tr> 
										<%if(b_cnt==1){%><td align='center' style="width:100px;" class="title" rowspan=<%=cnt1+1%>><%=ht.get("BR_GUBUN") %></td><%}%>
										<td align='center' style="height:30px;width:100px;" class="title"><%=ht.get("DEPT_GUBUN") %></td>
										<td align='center' width='100px'><%=AddUtil.parseDecimal(ht.get("CNT")+"")%></td>
										<td width='700px'>&nbsp;<%=ht.get("WORK_CONT") %></td>
									</tr>
									<%		} 
										}%>
									<tr> 										
										<td align='center' style="height:30px;" class="title">소계</td>
										<td align='center'><%=AddUtil.parseDecimal(sum_cnt1)%></td>
										<td align='center'> </td>
									</tr>	
										
    					  			<%	b_cnt = 0;
										for(int k=0;k<vt_size;k++){
        					  				Hashtable ht = (Hashtable)vt.elementAt(k);
        					  				if(String.valueOf(ht.get("BR_GUBUN")).equals("지점")){     
        					  					b_cnt++;
        							%>
									<tr> 
										<%if(b_cnt==1){%><td align='center' style="width:100px;" class="title" rowspan=<%=cnt2+1%>><%=ht.get("BR_GUBUN") %></td><%}%>
										<td align='center' style="height:30px;width:100px;" class="title"><%=ht.get("DEPT_GUBUN") %></td>
										<td align='center' width='100px'><%=AddUtil.parseDecimal(ht.get("CNT")+"")%></td>
										<td width='700px'>&nbsp;<%=ht.get("WORK_CONT") %></td>
									</tr>
									<%		} 
										}%>		
									<tr> 										
										<td align='center' style="height:30px;" class="title">소계</td>
										<td align='center'><%=AddUtil.parseDecimal(sum_cnt2)%></td>
										<td align='center'> </td>
									</tr>		
									<tr> 										
										<td align='center' style="height:30px;" class="title" colspan='2'>합계</td>
										<td align='center'><%=AddUtil.parseDecimal(sum_cnt1+sum_cnt2)%></td>
										<td>&nbsp;<%=b_cnt+1 %>개 거점 운영중</td>
									</tr>								
										
								</table>
								</td>
							</tr>
    <tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>IT기술 현황</span></td>
	  </tr>
    <tr>
        <td align=right><%=AddUtil.ChangeDate2(save_dt) %> 현재</td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>	
	<tr>		
								<td class='line'> 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td class='title' style="width:200px;height:35px;">전문기술인력</td>
										<td width='100px' align='center'><%=AddUtil.parseDecimal(sum_cnt3)%></td>
										<td width='700px'>&nbsp;시스템분석 및 설계, DB구축, 프로그램개발, 모바일개발</td>  
									</tr>
									<tr>
										<td class='title' style="width:200px;height:35px;">서버장비</td>
										<td width='100px' align='center'>28</td>
										<td width='700px'>&nbsp;IDC내 클라우두 운영환경, DB서버, 모바일운영시스템, 웹서비스시스템, FMS운영시스템, 보안/백업/테스트시스템 등</td>  
									</tr>
									<tr>
										<td  class='title' colspan='2' style="height:55px;">주요기술</td>										
										<td  style="width:700px;">&nbsp;FMS(운영시스템), ERP, 견적지원시스템, 영업 및 고객관리시스템, 통계시스템, SNS연계 마케팅지원 시스템(블로그, 페이스북 등), 모바일서비스</td>		  
									</tr>							
								</table>
								</td>
							</tr>
							
  </table>
</form>
</body>
</html>
