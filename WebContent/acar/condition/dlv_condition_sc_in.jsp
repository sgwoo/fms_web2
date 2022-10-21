<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"0":request.getParameter("dt");
	String t_st_dt = request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt = request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
	
	Vector stats = new Vector();
	stats = a_db.getDlvStats(s_kd, t_wd, dt,t_st_dt, t_end_dt);
	int stat_size = stats.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
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
				<td style="width: 550px;">
					<div style="width: 550px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>                      										
								<td class='title title_border' width='10%'>연번</td>
								<td class='title title_border' width='21%'>계약번호</td>
								<td class='title title_border' width='19%'>계약일</td>
								<td class='title title_border' width='29%'>상호</td>
			            		<td class='title title_border' width='24%'>차종</td>
            				</tr>            
						</table>
					</div>
				</td>
				
				<td style="width: 1500px;">
					<div style="width: 1500px;">
						<table class="inner_top_table table_layout" style="height: 60px;">			
							<tr>
			            		<td class='title title_border' width='6%'>차량번호</td>
			            		<td class='title title_border' width='10%'>차대번호</td>					
			            		<td class='title title_border' width='6%'>출고일</td>
			            		<td class='title title_border' width='6%'>등록일</td>
			            		<td class='title title_border' width='6%'>영업구분</td>	
			            		<td class='title title_border' width='6%'>영업담당</td>            		
			            		<td class='title title_border' width='7%'>소속사</td>
								<td class='title title_border' width='7%'>영업지점</td>
			            		<td class='title title_border' width='6%'>자체출고</td>	
								<td class='title title_border' width='7%'>제조사</td>					
			            		<td class='title title_border' width='7%'>출고지점</td>
			            		<td class='title title_border' width='12%'>차명</td>
			            		<td class='title title_border' width='7%'>구입가격</td>
			            		<td class='title title_border' width='7%'>구입공급가</td>
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
				<td style="width: 550px;">
					<div style="width: 550px;">
						<table class="inner_top_table left_fix">  
<%
	if(stat_size > 0) {
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
%>            	
			           		 <tr style="height: 25px;"> 
			           			<td class='center content_border' width='10%'><%=i+1%></td>
			           			<td class='CENTER content_border' width='21%'><%=stat.get("RENT_L_CD")%></td>
			           			<td class='CENTER content_border' width='19%'><%=stat.get("RENT_DT")%></td>
								<td class='left content_border' width='29%'>&nbsp;<span title='<%=stat.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(stat.get("FIRM_NM")), 8)%></span></td>
			            		<td class='left content_border' width='24%'>&nbsp;<span title='<%=stat.get("CAR_NM")%>'><%=Util.subData(String.valueOf(stat.get("CAR_NM")), 8)%></span></td>            		            		
			            	</tr>
					 <%		}%>
			                <tr>              
			        		    <td class="title content_border center " colspan=5 >합계</td>                    
			                </tr>
			         <%} else  {%>  
				           	<tr>
						        <td class='center content_border'>등록된 데이타가 없습니다</td>
						    </tr>	              
			          <%}	%>
				         </table>
				     </div>
			    </td>
			    
			   	<td style="width: 1500px;">
					  <div style="width: 1500px;">
						<table class="inner_top_table table_layout">		
<%
	if(stat_size > 0) {
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(stat.get("CAR_F_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(stat.get("CAR_FS_AMT")));
				
%>            				
							 <tr style="height: 25px;"> 				
			                    <td class='center content_border' width='6%'><%=stat.get("CAR_NO")%></td>
			                    <td class='center content_border' width='10%'><%=stat.get("CAR_NUM")%></td>		              		
			                    <td class='center content_border' width='6%'><%=stat.get("DLV_DT")%></td>            		
			                    <td class='center content_border' width='6%'><%=stat.get("INIT_REG_DT")%></td>            		
			                    <td class='center content_border' width='6%'><%=stat.get("PUR_BUS_ST")%></td>            		
			                    <td class='center content_border' width='6%'><span title='<%=stat.get("EMP_NM")%>'><%=Util.subData(String.valueOf(stat.get("EMP_NM")), 3)%></span></td>
					   			<td class='center content_border' width='7%'><%=stat.get("NM1")%></td>					
			                    <td class='center content_border' width='7%'><span title='<%=stat.get("BUS_OFF")%>'><%=Util.subData(String.valueOf(stat.get("BUS_OFF")), 6)%></span></td>					
			                    <td class='center content_border' width='6%'><%=stat.get("ONE_SELF")%></td>
					   			<td class='center content_border' width='7%'><%=stat.get("NM2")%></td>					
			                    <td class='center content_border' width='7%'><span title='<%=stat.get("DLV_OFF")%>'><%=Util.subData(String.valueOf(stat.get("DLV_OFF")), 6)%></span></td>
			            	    <td class='center content_border' width='12%'>&nbsp;<span title='<%=stat.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(stat.get("CAR_NAME")), 14)%></span></td>
			            	    <td class='right content_border' width='7%'><%=Util.parseDecimal(String.valueOf(stat.get("CAR_F_AMT")))%></td>					
			            	    <td class='right content_border' width='7%'><%=Util.parseDecimal(String.valueOf(stat.get("CAR_FS_AMT")))%></td>					
			           	    </tr>
			<%
				}
			%>
							 <tr> 
			                	<td class="title content_border" colspan='12'>&nbsp;</td>           			
            					<td class="title content_border" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>    		            		
            					<td class="title content_border" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>   	
			                </tr>
					<%} else  {%>  
				           	<tr>
						        <td width="1500" colspan="14"  class='center content_border'>&nbsp;</td>
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
</html>