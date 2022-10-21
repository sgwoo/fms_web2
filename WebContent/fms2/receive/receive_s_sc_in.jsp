<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase" />
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String gubun0 	= request.getParameter("gubun0")==null?"1":request.getParameter("gubun0");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String height = request.getParameter("height")==null?"":request.getParameter("height");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	long greq_amt = 0;	//청구
	long gdraw_amt = 0;	//회수	
	long gip_amt = 0;	//입금
	long grate_amt = 0;   //수수료
	long grate_amt1 = 0;   //소송비용
	long grate_amt2 = 0;   //압류비용
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	Vector vt = re_db.getClsBandDocList( "", gubun0,  gubun2, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);		
	int vt_size = vt.size();
	
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
				<td style="width: 730px;">
					<div style="width: 740px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>									        		    
			        		    <td width='40' class='title title_border' >연번</td>	               
			        		    <td width='120' class='title title_border'>계약번호</td>
			        		    <td width='180' class='title title_border'>상호</td>
			        		    <td width='150' class='title title_border'>사업자/주민번호</td>
			        		    <td width='100' class='title title_border'>차량번호</td>
			        		   	<td width='150' class='title title_border'>차명</td>			        		   	
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							<tr>
								<td width='70' class='title title_border'>구분</td>		
							    <td width='130' class='title title_border'>위임업체</td>	
							    <td width='90' class='title title_border'>청구일자</td>	
							    <td width='90' class='title title_border'>해지일자</td>		
							    <td width='80' class='title title_border'>해지구분</td>	
							    <td width='100' class='title title_border'>위임금액</td>	
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
				<td style="width: 730px;">
					<div style="width: 740px;">
						<table class="inner_top_table left_fix">
	    	 <%  if(vt_size > 0)	{  %>
				<%
						for(int i = 0 ; i < vt_size ; i++)
						{
							Hashtable ht = (Hashtable)vt.elementAt(i);	%>
  	            
							 <tr style="height: 25px;"> 
								<td  width='40' class='center content_border'><%=i+1%></td>				
								<td  width='120' class='center content_border'>
									<a href="javascript:parent.cls_action('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
								<%=ht.get("RENT_L_CD")%>
								</a></td>
								<td width='180' class='left content_border'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>' ><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 12)%></span></td>			
								<td width='150' class='center content_border'>
								<% if ( String.valueOf(ht.get("CLIENT_ST")).equals("2") ) { %>
								<%=ht.get("SSN1")%>
								<% } else {%>
								<%=ht.get("ENP_NO")%>
								<%} %>
								</td>
								<td width='100' class='center content_border'><%=ht.get("CAR_NO")%></td>		
								<td width='150' class='center content_border'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 9)%></td>		
							</tr>
			         	<%      } %>
			         	  	<tr>              
			        			     <td class="title content_border" colspan=7 align='center'>합계</td>                    
			                </tr>			
			    <%} else  {%>  
				           	<tr>
						            <td align='center content_border'>등록된 데이타가 없습니다</td>
						    </tr>	              
				 <%}	%>
				         </table>
				     </div>
				  </td>	
				  
				  <td>
		  			<div>
						<table class="inner_top_table table_layout">
				<%  if(vt_size > 0)	{  %>
				<%
						for(int i = 0 ; i < vt_size ; i++)
						{
							Hashtable ht = (Hashtable)vt.elementAt(i);		%>
				
						     <tr style="height: 25px;"> 
						   		<td  width='70' class='center content_border'><%=ht.get("GUBUN_NM")%></td>	
						   		<td  width='130' class='center content_border'><%=ht.get("N_VEN_NAME")%></td>			
								<td  width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>													
								<td  width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>	
								<td  width='80' class='center content_border'><%=ht.get("CLS_ST_NM")%></td>	
								<td  width='100' class='right content_border'><%=AddUtil.parseDecimal((String) ht.get("TOT_AMT"))%></td>									
							</tr>
			          <%
			         			greq_amt = greq_amt + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT"))); //청구
			           } %> 	
			         		<tr> 
			                   <td class="title content_border">&nbsp;</td>
			                   <td class="title content_border">&nbsp;</td>        
			                   <td class="title content_border">&nbsp;</td>   
			                   <td class="title content_border">&nbsp;</td>
			                   <td class="title content_border">&nbsp;</td>
							   <td class="title content_border right"><%=Util.parseDecimal(greq_amt)%></td><!--청구금액  -->
				            </tr>				                			
					<%} else  {%>  
					       	<tr>
							    <td width="970" colspan="8" class='center content_border'>&nbsp;</td>
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
	
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
