<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	
	Vector debts = ad_db.getDebtSettleList(gubun1, gubun2, gubun3, gubun4, s_kd, t_wd, sort_gubun, asc);
	int debt_size = debts.size();
	
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

</head>

<body>

<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 380px;">
					<div style="width: 380px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>  
					           <td width=40 class='title title_border' style='height:50'>연번</td>
					           <td width=40 class='title title_border'>구분</td>		
					           <td width=110 class='title title_border'>금융사</td>								
					           <td width=110 class='title title_border'>대출번호</td>
					           <td width=80 class='title title_border'>차량번호</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">							
							<colgroup>
				       			<col width="70">
				       			<col width="150">
				       			<col width="40">
				       			<col width="70">				       			
				       			<col width="70"> 				       							       					       		
				       			<col width="120">
				       			
				       			<col width="120">
				       			<col width="120">
				       			<col width="120">
				       			<col width="120">
				       			<col width="120">
				       			<col width="120">
				       			<col width="120">
				       			<col width="120">				       			
				       			<col width="120">		       			
				       			<col width="120">		       			
				       			<col width="120">		       			
				       			<col width="120">
				       			<col width="120">
				       		</colgroup>
												
							<tr>
								<td width=70 rowspan="2" class='title title_border'>거래처<br>코드</td>								
								<td width=150 rowspan="2" class='title title_border'>계좌번호</td>
								<td width=40 rowspan="2" class='title title_border'>이율</td>				
								<td width=70 rowspan="2" class='title title_border'>대출일자</td>					
								<td width=70 rowspan="2" class='title title_border'>완료<br>예정일</td>					
								<td width=120 rowspan="2" class='title title_border'>잔액</td>
								<td colspan="13" class='title title_border' style='height:25'>월상환금액</td>
							</tr>
							<tr>
						      <td width=120 class='title title_border' style='height:25'>합계</td>
							  <td width=120 class='title title_border'>1월</td>
						      <td width=120 class='title title_border'>2월</td>
						      <td width=120 class='title title_border'>3월</td>
						      <td width=120 class='title title_border'>4월</td>
						      <td width=120 class='title title_border'>5월</td>
						      <td width=120 class='title title_border'>6월</td>
						      <td width=120 class='title title_border'>7월</td>
						      <td width=120 class='title title_border'>8월</td>
						      <td width=120 class='title title_border'>9월</td>
						      <td width=120 class='title title_border'>10월</td>
						      <td width=120 class='title title_border'>11월</td>
						      <td width=120 class='title title_border'>12월</td>
					      </tr>
	        		
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb">
			<tr>
				<td style="width: 380px;">
					<div style="width: 380px;">
						<table class="inner_top_table left_fix">  						

		<%	if(debt_size > 0){%>
		<%		for(int i = 0 ; i < debt_size ; i++){
					Hashtable debt = (Hashtable)debts.elementAt(i);
					String st1 = String.valueOf(debt.get("ST1"));
					String st2 = String.valueOf(debt.get("ST2"));
					
					String td_color = "";
					if(st1.equals("납부완료")) td_color = " class=' is center content_border' ";			
				
		%>
							<tr>
								<td <%=td_color%> class='center content_border' width=40><%=i+1%></td>
								<td <%=td_color%> class='center content_border' width=40><%=st2%></td>		
								<td <%=td_color%> class='center content_border' width=110><span title='<%=debt.get("CPT_NM")%>'><%=Util.subData(String.valueOf(debt.get("CPT_NM")), 5)%></span></td>								
								<td <%=td_color%> class='center content_border' width=110><span title='<%=debt.get("LEND_NO")%>'><%=Util.subData(String.valueOf(debt.get("LEND_NO")), 13)%></span>
									<%if(String.valueOf(debt.get("LEND_NO")).equals("") && st2.equals("묶음")){%>
									<%=debt.get("LEND_ID")%> <%=debt.get("RTN_SEQ")%>
									<%}else if(String.valueOf(debt.get("LEND_NO")).equals("") && st2.equals("개별")){%>
									<%=debt.get("RENT_L_CD")%>
									<%}%>
								</td>
								<td <%=td_color%>  class='center content_border' width=80><%=debt.get("CAR_NO")%></td>					
							</tr>					
			<%		} %>
			                <tr> 
						        <td colspan="5" class="title content_border center">&nbsp;합계</td>
					        </tr>
			<%} else  {%>  
				           	<tr>
						           <td class='center content_border'>등록된 데이타가 없습니다</td>
						    </tr>	              
		     <%}	%>	   
			            </table>
			         </div>            
				  </td>
				  
				  <td>			
		     	 	<div>
						<table class="inner_top_table table_layout">       

<%	if(debt_size > 0){%>		  		
<%		for(int i = 0 ; i < debt_size ; i++){
						Hashtable debt = (Hashtable)debts.elementAt(i);
						String st1 = String.valueOf(debt.get("ST1"));
						
						//if (!st1.equals("납부완료") ) continue;
			
						total_amt1   = total_amt1   + AddUtil.parseLong(String.valueOf(debt.get("AMT1")));
						total_amt2   = total_amt2   + AddUtil.parseLong(String.valueOf(debt.get("AMT2")));
						total_amt3   = total_amt3   + AddUtil.parseLong(String.valueOf(debt.get("AMT3")));
						total_amt4   = total_amt4   + AddUtil.parseLong(String.valueOf(debt.get("AMT4")));
						total_amt5   = total_amt5   + AddUtil.parseLong(String.valueOf(debt.get("AMT5")));
						total_amt6   = total_amt6   + AddUtil.parseLong(String.valueOf(debt.get("AMT6")));
						total_amt7   = total_amt7   + AddUtil.parseLong(String.valueOf(debt.get("AMT7")));
						total_amt8   = total_amt8   + AddUtil.parseLong(String.valueOf(debt.get("AMT8")));
						total_amt9   = total_amt9   + AddUtil.parseLong(String.valueOf(debt.get("AMT9")));
						total_amt10  = total_amt10  + AddUtil.parseLong(String.valueOf(debt.get("AMT10")));
						total_amt11  = total_amt11  + AddUtil.parseLong(String.valueOf(debt.get("AMT11")));
						total_amt12  = total_amt12  + AddUtil.parseLong(String.valueOf(debt.get("AMT12")));
						total_amt13  = total_amt13  + AddUtil.parseLong(String.valueOf(debt.get("AMT13")));
						total_amt14  = total_amt14  + AddUtil.parseLong(String.valueOf(debt.get("AMT14")));		
						
						String td_color = "";
						if(st1.equals("납부완료")) td_color = " class=' is center content_border' ";
						String td_color2 = "";
						if(st1.equals("납부완료")) td_color2 = " class=' is right content_border' ";
						
						//if (!st1.equals("납부완료") ) continue;
			%>					
							<tr>
								<td <%=td_color%> class='center content_border' width=70><%=debt.get("VEN_CODE")%></td>				
								<td <%=td_color%> class='center content_border' width=150><%=debt.get("DEPOSIT_NO")%></td>				
								<td <%=td_color%> class='center content_border' width=40><%=debt.get("LEND_INT")%></td>
								<td <%=td_color%> class='center content_border' width=70><%=debt.get("LEND_DT")%></td>
								<td <%=td_color%> class='center content_border' width=70><%=debt.get("END_DT")%></td>				
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT14")))%></td>						
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT13")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT1")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT2")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT3")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT4")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT5")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT6")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT7")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT8")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT9")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT10")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT11")))%></td>
								<td <%=td_color2%> class='right content_border' width=120><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT12")))%></td>
						    </tr>
<%						
		}%>
					        <tr> 
								<td class="title title_border">&nbsp;</td>		  
								<td class="title title_border">&nbsp;</td>
								<td class="title title_border">&nbsp;</td>			
								<td class="title title_border">&nbsp;</td>			
								<td class="title title_border">&nbsp;</td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt14)%></td>			
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt13)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt2)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt3)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt4)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt5)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt6)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt7)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt8)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt9)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt10)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt11)%></td>
								<td class="title title_border" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt12)%></td>
					        </tr>		
				
				<%} else  {%>  
				         	<tr>
						         <td class='center content_border'>등록된 데이타가 없습니다</td>
						    </tr>	              
				     <%}	%>			
				     
					 	  </table>
			   	    </div>
			    </td>
			</tr>
		</table>
	</div>
</div>		    

</form>
</body>

<script language='javascript'>
<!--

//-->
</script>
</html>