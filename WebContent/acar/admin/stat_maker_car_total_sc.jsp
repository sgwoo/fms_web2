<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String gubun2 	= request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");	
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
	
	int sum1 = 0;
	int sum2 = 0;
	int sumt1 = 0;
	int sumt2 = 0;
	int sumt3 = 0;
	int sumt4 = 0;
	int sumt5 = 0;
	int sumt0 = 0;
	int sumt = 0;
	
	Vector cars = ad_db.getStatMakerCarMon3(gubun2, gubun3, gubun4, st_dt, end_dt);
	int cars_size = cars.size();
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.right { text-align:right; padding-right: 5px;}
.total .right { font-weight: bold;}
</style>
<script type="text/javascript">
function excel_list(){
	var fm = document.form1;
	fm.target = "_blank";
	fm.action = "stat_maker_car_total_excel.jsp";
	fm.submit();
}
</script>
</head>
<body leftmargin="15" rightmargin=0>
<form name="form1">
<input type="hidden" name="gubun2" value="<%=gubun2%>" >
<input type="hidden" name="gubun3" value="<%=gubun3%>" >
<input type="hidden" name="gubun4" value="<%=gubun4%>" >
<input type="hidden" name="st_dt" value="<%=st_dt%>" >
<input type="hidden" name="end_dt" value="<%=end_dt%>" >
<table border="0" cellspacing="0" cellpadding="0" width="1475px" class="top">
	<tr> 
	    <td colspan="6">
	    	<label><i class="fa fa-check-circle"></i> 제조사별 현황 </label>&nbsp;
	    	<input type="button" class="button" value="EXCEL" onClick="javascript:excel_list();">
	    </td>
	</tr>
	<tr>
	    <td class="top">
    		<table border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class=line>
        			    <table width="350px" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                		        <td class="title" colspan="4">현대</td>	  				  				  				  				  				  
            		        </tr>
            		        <tr> 
                		        <td class="title" width="165px" rowspan="2" style="height:50px;">차종</td>
                		        <td class="title" colspan="3">보유대수</td>				  				  				  				  
            		        </tr>
            		        <tr> 
                		        <td class="title" width="80px">B2B사업운영팀</td>
                		        <td class="title" width="50px">영업소</td>	
                		        <td class="title" width="*">소계</td>	  		  				  				  				  				  
            		        </tr>
            		        
                    		<%
	                    		for(int i=0; i<cars.size(); i++){
	            					Hashtable ht = (Hashtable)cars.elementAt(i);
            						if(ht.get("CAR_COMP_ID").equals("0001")){            							
									 	sum1 = sum1+AddUtil.parseInt(String.valueOf(ht.get("CNT1")));
									 	sum2 = sum2+AddUtil.parseInt(String.valueOf(ht.get("CNT2")));	
									 	sumt1 = sumt1+AddUtil.parseInt(String.valueOf(ht.get("TOTAL")));
            			 	%>
                    		<tr>           
                                <td class="title"><%= ht.get("CAR_NM") %></td>
                                <td class="right"><%= ht.get("CNT1") %></td>
                                <td class="right"><%= ht.get("CNT2") %></td>
                                <td class="right"><%= ht.get("TOTAL") %></td>     
                            </tr>
                           <%		}
								} %>
                            <tr class="total">           
                                <td class="title">합계</td>
                                <td class="right"><%=sum1%></td>
                                <td class="right"><%=sum2%></td>
                                <td class="right"><%=sumt1%></td>
                            </tr>	
						</table>
					</td>
                </tr>          
            </table>
	    </td>
	    <td class="top">
    		<table border="0" cellspacing="0" cellpadding="0">
                <tr> 
					<td class=line>
                        <table width="225px" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                		        <td class="title" colspan="2">기아</td>	  				  				  				  				  				  
            		        </tr>
            		        <tr> 
                    		    <td class="title" width="165px" style="height:50px;">차종</td>
                    		    <td class="title" width="*">보유대수</td>  				  				  				  				  
            		        </tr>
                    		<%
	                    		for(int i=0; i<cars.size(); i++){
	            					Hashtable ht = (Hashtable)cars.elementAt(i);
            						if(ht.get("CAR_COMP_ID").equals("0002")){            								
									 	sumt2 = sumt2+AddUtil.parseInt(String.valueOf(ht.get("TOTAL")));
            			 	%>
                    		<tr>           
                                <td class="title"><%= ht.get("CAR_NM") %></td>
                                <td class="right"><%= ht.get("TOTAL") %></td> 
                            </tr>
                           <%		}
								} %>
                            <tr class="total">           
                                <td class="title">합계</td>
                                <td class="right"><%= sumt2 %></td>
                            </tr>		
                        </table>
	                </td>
                </tr>          
            </table>
	    </td>
	    <td class="top">
    		<table border="0" cellspacing="0" cellpadding="0">
                <tr> 
					<td class=line>
                        <table width="225px" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                		        <td class="title" colspan="2">르노</td>  				  				  				  				  				  
            		        </tr>
            		        <tr> 
                    		    <td class="title" width="165px" style="height:50px;">차종</td>
                    		    <td class="title" width="*">보유대수</td>	  				  				  				  				  
            		        </tr>
            		        
                    		<%
	                    		for(int i=0; i<cars.size(); i++){
	            					Hashtable ht = (Hashtable)cars.elementAt(i);
            						if(ht.get("CAR_COMP_ID").equals("0003")){           								
									 	sumt3 = sumt3+AddUtil.parseInt(String.valueOf(ht.get("TOTAL")));
            			 	%>
                    		<tr>           
                                <td class="title"><%= ht.get("CAR_NM") %></td>
                                <td class="right"><%= ht.get("TOTAL") %></td> 
                            </tr>
                           <%		}
								} %>
                            <tr class="total">           
                                <td class="title">합계</td>
                                <td class="right"><%= sumt3 %></td>
                            </tr>		
                        </table>
	                </td>
                </tr>          
            </table>
	    </td>
	    <td class="top">
    		<table border="0" cellspacing="0" cellpadding="0">
                <tr> 
					<td class=line>
                        <table width="225px" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                    		    <td class="title" colspan="2">한국GM</td>	  				  				  				  				  				  
            		        </tr>
            		        <tr> 
                    		    <td class="title" width="165px" style="height:50px;">차종</td>
                    		    <td class="title" width="*">보유대수</td>  				  				  				  				  
            		        </tr>
                    		<%
	                    		for(int i=0; i<cars.size(); i++){
	            					Hashtable ht = (Hashtable)cars.elementAt(i);
            						if(ht.get("CAR_COMP_ID").equals("0004")){            								
									 	sumt4 = sumt4+AddUtil.parseInt(String.valueOf(ht.get("TOTAL")));
            			 	%>
                    		<tr>           
                                <td class="title"><%= ht.get("CAR_NM") %></td>
                                <td class="right"><%= ht.get("TOTAL") %></td> 
                            </tr>
                           <%		}
								} %>
                            <tr class="total">           
                                <td class="title">합계</td>
                                <td class="right"><%= sumt4 %></td>
                            </tr>		
                        </table>
	                </td>
                </tr>          
            </table>
	    </td>
	    <td class="top">
    		<table border="0" cellspacing="0" cellpadding="0">
                <tr> 
					<td class=line>
                        <table width="225px" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                    		    <td class="title" colspan="2">쌍용</td>				  				  				  				  				  
            		        </tr>
            		        <tr> 
                    		    <td class="title" width="165px" style="height:50px;">차종</td>
                    		    <td class="title" width="*">보유대수</td>	  				  				  				  				  
            		        </tr>
                    		<%
	                    		for(int i=0; i<cars.size(); i++){
	            					Hashtable ht = (Hashtable)cars.elementAt(i);
            						if(ht.get("CAR_COMP_ID").equals("0005")){            								
									 	sumt5 = sumt5+AddUtil.parseInt(String.valueOf(ht.get("TOTAL")));
            			 	%>
                    		<tr>           
                                <td class="title"><%= ht.get("CAR_NM") %></td>
                                <td class="right"><%= ht.get("TOTAL") %></td> 
                            </tr>
                           <%		}
								} %>
                            <tr class="total">           
                                <td class="title">합계</td>
                                <td class="right"><%= sumt5 %></td>
                            </tr>		
                        </table>
	                </td>
                </tr>          
            </table>
	    </td>
	    <td class="top">
    		<table border="0" cellspacing="0" cellpadding="0">
                <tr> 
					<td class=line>
                        <table width="225px" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                    		    <td class="title" colspan="2">기타</td>		  				  				  				  				  				  
            		        </tr>
            		        <tr> 
                    		    <td class="title" width="165px" style="height:50px;">차종</td>
                    		    <td class="title" width="*">보유대수</td>  				  				  				  				  
            		        </tr>
                    		<%
	                    		for(int i=0; i<cars.size(); i++){
	            					Hashtable ht = (Hashtable)cars.elementAt(i);
            						if(ht.get("CAR_COMP_ID").equals("0000")){            								
									 	sumt0 = sumt0+AddUtil.parseInt(String.valueOf(ht.get("TOTAL")));		
            			 	%>
                    		<tr>           
                                <td class="title"><%= ht.get("CAR_NM") %></td>
                                <td class="right"><%= ht.get("TOTAL") %></td> 
                            </tr>
                           <%		}
								} %>
                            <tr class="total">           
                                <td class="title">합계</td>
                                <td class="right"><%= sumt0 %></td>
                            </tr>	<tr class="total">           
                                <td class="title">총 대수</td>
                                <td class="right"><%=sumt1+sumt2+sumt3+sumt4+sumt5+sumt0%></td>
                            </tr>	
                        </table>
	                </td>
                </tr>          
            </table>
	    </td>
	</tr>
</table>
</form>
</body>
</html>
