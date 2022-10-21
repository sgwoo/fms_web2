<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rc_db" scope="page" class="acar.receive.ReceiveDatabase" />
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
	
	long gtotal_amt = 0;	
	long grtotal_amt = 0;	
	long gitotal_amt = 0;	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		

	Vector vt = rc_db.getClsGurDocList(br_id, gubun0,  gubun2, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);		
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

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 530px;">
					<div style="width: 530px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
								<td width='40' class='title title_border' >연번</td>	               
		        		    	<td width='120' class='title title_border'>계약번호</td>
		        		    	<td width='120' class='title title_border'>상호</td>
		        		    	<td width='100' class='title title_border'>차량번호</td>
		        		   		<td width='150' class='title title_border'>차명</td>			          		  
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							 <colgroup>
				                <col width="210">
				       			<col width="100">
				       			<col width="90">
				       			<col width="100">
				       			<col width="120">	
				       			<col width="120">	
				       			<col width="120">	
				       			<col width="100">	
				       			<col width="100">		       			
				       			<col width="100">		       			
				       			<col width="100">
				       			<col width="100">				       			
				       		</colgroup>
		       		      
							<tr>
								<td rowspan=2 class='title title_border'>증권번호</td>
							    <td colspan="3" class='title title_border' width='290'>진행사항</td>						
							    <td colspan="3" class='title title_border' width='270'>담당자</td>						
							    <td colspan="5" class='title title_border' width='470'>보증보험금</td>			
							</tr>
							<tr>		
							    <td width='100' class='title title_border'>청구일자</td>		
							    <td width='90' class='title title_border'>보상자료제출</td>	
							    <td width='100'class='title title_border'>종료예정일</td>		 <!--진행 -->				    
							   	<td  width='120' class='title title_border'>부서명</td>
					    	   	<td  width='120' class='title title_border'>직급/성명</td>						
						    	<td  width='120' class='title title_border'>연락처</td>  <!--담당자  -->
					    	   	<td  width='100'class='title title_border'>가입금액</td>	
					    	   	<td  width='100'class='title title_border'>청구금액</td>	
					    	   	<td  width='100' class='title title_border'>입금예정일</td>	
					    	   	<td  width='100' class='title title_border'>입금액</td>	
					    	   	<td  width='100' class='title title_border'>입금일자</td>	 <!-- 보증보험금 -->
						   	</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb" >
			<tr>
				<td style="width: 530px;">
					<div style="width: 530px;">
						<table class="inner_top_table left_fix">	    

	    		 <%  if(vt_size > 0)	{  %>
					<%
						for(int i = 0 ; i < vt_size ; i++)
						{
							Hashtable ht = (Hashtable)vt.elementAt(i);	%>
  	            
						 <tr style="height: 25px;"> 
							<td  width='40' class='center content_border'><%=i+1%></td>				
							<td  width='120' class='center content_border'>
								<a href="javascript:parent.upd_action('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
							<%=ht.get("RENT_L_CD")%>
							</a></td>
							<td  width='120' class='center content_border'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>' ><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>			
							<td  width='100' class='center content_border'><span title='<%=ht.get("CAR_NO")%>'>
			                        <%if(String.valueOf(ht.get("PREPARE")).equals("9") || String.valueOf(ht.get("PREPARE")).equals("4") ){%>
				                  			 <b><font color="green"><%=Util.subData(String.valueOf(ht.get("CAR_NO")), 15)%></font></b>
				                     <% }  else { %>
				                    		<%=Util.subData(String.valueOf(ht.get("CAR_NO")), 15)%>
				                     <%} %> 
			                    </span>
							</td>		
							<td  width='150' class='center content_border'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 8)%></td>				
												
						</tr>
		         	<%      } %>
		         	  		<tr>              
		        			     <td class="title content_border center" colspan=5 >합계</td>                    
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

				<%  if(vt_size > 0)	{  %>
				<%
						for(int i = 0 ; i < vt_size ; i++)
						{
							Hashtable ht = (Hashtable)vt.elementAt(i);
							String td_color = "";
				%>
				
				    <tr style="height: 25px;"> 
				  		<td  width='210' class='center content_border' ><%=ht.get("GI_NO")%></td>				
						<td  width='100' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>	
						<td  width='90' class='center content_border'></td>		
						<td  width='100' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("GI_END_DT")))%></td>	
						
						<td  width='120' class='center content_border'></td>	
						<td  width='120' class='center content_border'><%=(String) ht.get("GUAR_NM")%></td>		
						<td  width='120' class='center content_border'><%=(String) ht.get("GUAR_TEL")%></td>		
						
						<td  width='100' class='right content_border'><%=AddUtil.parseDecimal((String) ht.get("GI_AMT"))%></td>	
						<td  width='100' class='right content_border'><%=AddUtil.parseDecimal((String) ht.get("REQ_AMT"))%></td>		
						<td  width='100' class='center content_border'></td>		
						<td  width='100' class='right content_border'><%=AddUtil.parseDecimal((String) ht.get("IP_AMT"))%></td>	
						<td  width='100' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("IP_DT")))%></td>						
					</tr>
	          <%
	          	 	 	gtotal_amt = gtotal_amt + AddUtil.parseLong(String.valueOf(ht.get("GI_AMT")));
						grtotal_amt = grtotal_amt + AddUtil.parseLong(String.valueOf(ht.get("REQ_AMT")));
						gitotal_amt = gitotal_amt + AddUtil.parseLong(String.valueOf(ht.get("IP_AMT")));
	          
	           } %> 	
	         	  <tr> 
	                  <td class="title content_border">&nbsp;</td>
	                  <td class="title content_border">&nbsp;</td>
	                  <td class="title content_border">&nbsp;</td>        
	                  <td class="title content_border">&nbsp;</td><!-- 진행사항 -->
	                  <td class="title content_border">&nbsp;</td>
	                  <td class="title content_border">&nbsp;</td>        
	                  <td class="title content_border">&nbsp;</td><!-- 담당자 -->
	                  <td class="title content_border right"><%=Util.parseDecimal(gtotal_amt)%></td><!-- 보증보험 -->
	                  <td class="title content_border right"><%=Util.parseDecimal(grtotal_amt)%></td><!-- 청구금액-->	                 
					  <td class="title content_border">&nbsp;</td><!-- 입금예정일 -->
					 <td class="title content_border right"><%=Util.parseDecimal(gitotal_amt)%></td><!-- 보증보험 입금액-->
	                 <td class="title content_border">&nbsp;</td><!-- 입금일자 -->
		            </tr>
		                			
	<%} else  {%>  
			       	<tr>
					    <td  colspan="12" class='center content_border'>&nbsp;</td>
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
