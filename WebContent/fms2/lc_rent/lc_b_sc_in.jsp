<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count =0;
	
	
	
	Vector vt = a_db.getHoldContList_20160614(s_kd, t_wd, andor, gubun2, gubun3);
	int cont_size = vt.size();
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
				<td style="width: 520px;">
					<div style="width: 520px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>  				                
			                    <td width='50' class='title title_border' >연번</td>
				                <td width='50' class='title title_border'>결재</td>
			                    <td width='130' class='title title_border'>계약번호</td>
			                    <td width='85' class='title title_border'>계약일<br>(승계일자)</td>
			                    <td width="120" class='title title_border'>고객</td>
			                    <td width="85" class='title title_border'>대여개시일</td>
                    
                     		
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
						  <colgroup>
				       			<col width="110">
				       			<col width="90">
				       			<col width="30">
				       			<col width="90">
				       			       				       					       			
				       			<col width="70">
				       			<col width="70">
				       			<col width="70">
				       			<col width="70">
				       			<col width="70">
				       			
				       			<col width="70">
				       			<col width="70">
				       			<col width="70">
				       			<col width="70">      			
				       			<col width="70">		       			
				       		</colgroup>
				       		<tr>
			                  <td colspan="4" class='title title_border' >자동차</td>	
			        		  <td colspan="5" class='title title_border' >계약</td>
			        		  <td colspan="5" class='title title_border' >관리</td>        		  
			        	    </tr>
			        		<tr>
			        		  <td width="110" class='title title_border'>차종</td>
			        		  <td width="90" class='title title_border'>차량번호</td>
			        		  <td width="30" class='title title_border'>지역</td>		  
			        		  <td width="90" class='title title_border'>관리번호</td>
			        		  
			        	      <td width='70' class='title title_border'>계약구분</td>
			        	      <td width='80' class='title title_border'>영업구분</td>
			        	      <td width='70' class='title title_border'>차량구분</td>
			        	      <td width='70' class='title title_border'>용도구분</td>
			        	      <td width='70' class='title title_border'>관리구분</td>		        	   
			        	   
			        	      <td width='70' class='title title_border'>영업지점</td>
		        		      <td width='70' class='title title_border'>관리지점</td>
			        		  <td width='70' class='title title_border'>최초영업자</td>        		  
			        		  <td width='70' class='title title_border'>영업대리인</td>
			        		  <td width='70' class='title title_border'>영업담당자</td>
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
				<td style="width: 520px;">
					<div style="width: 520px;">
						<table class="inner_top_table left_fix">  
						
				     <%if(cont_size > 0){%> 
			            <%	for(int i = 0 ; i < cont_size ; i++){
			    				Hashtable ht = (Hashtable)vt.elementAt(i);
			    				if(String.valueOf(ht.get("CAR_ST")).equals("월렌트")) continue;
			    				count++;
			    	     %>
			                <tr> 
			                    <td width='50' class='center content_border'><%=count%>&nbsp;<font color=red><%=ht.get("REG_STEP")%></font></td>
			                    <td width='50' class='center content_border'><%if(String.valueOf(ht.get("SANCTION_ST")).equals("요청")){%><font color=red><%=ht.get("SANCTION_ST")%><%if(a_db.getSanctionUserType(String.valueOf(ht.get("BUS_ID")),String.valueOf(ht.get("BUS_NM"))) == 1){%>2<%}%></font><%}else{%><font color=#000000><%=ht.get("SANCTION_ST")%></font><%}%></td>		  
			                    <td width='130' class='center content_border'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>', '<%if(String.valueOf(ht.get("CNG_ST")).equals("")){%><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%><%}else{%><%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%><%}else{%><%=ht.get("EXT_ST2")%><%}%><%}%>', '<%=ht.get("SANCTION_ST")%>','<%=ht.get("REG_STEP")%>','<%=ht.get("CLIENT_ID")%>','<%=ht.get("CAR_ST")%>','<%=ht.get("BUS_ST")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
			                    <td width='85' class='center content_border'>
			                        <%if(String.valueOf(ht.get("CNG_ST")).equals("계약승계") && String.valueOf(ht.get("EXT_ST2")).equals("")){%>
			                            <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%>
			                        <%}else{%>
			                            <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>
			                        <%}%>
			                    </td>
			                    <td width='120' class='center content_border'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></td>
			                    <td width='85' class='center content_border'>
			                            <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>
			                    </td>
			                </tr>
			         <%		}	%>
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
					  <%if(cont_size > 0){%>	   
			    	    <%	for(int i = 0 ; i < cont_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("CAR_ST")).equals("월렌트")) continue;				
							%>
			        		<tr>
			        		    <td width='110' class='center content_border'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 7)%></td>
			        		    <td width='90' class='center content_border'><%=ht.get("CAR_NO")%></td>					
			        		    <td width='30' class='center content_border'><%=ht.get("CAR_EXT")%></td>
			        		    <td width='90' class='center content_border'><%=ht.get("CAR_DOC_NO")%></td>
			        		  
			        		    <td width='70' class='center content_border'><%if(String.valueOf(ht.get("CNG_ST")).equals("")){%><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%><%}else{%><%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%><%}else{%><%=ht.get("EXT_ST2")%><%}%><%}%></td>
			        		    <td width='70' class='center content_border'><%=ht.get("BUS_ST")%></td>
			        		    <td width='70' class='center content_border'><%=ht.get("CAR_GU")%></td>
			        		    <td width='70' class='center content_border'><%=ht.get("CAR_ST")%></td>        		  
			        		    <td width='70' class='center content_border'><%=ht.get("RENT_WAY")%></td>	
			        		    				
			        		    <td width='70' class='center content_border'><%=ht.get("BRCH_ID")%></td>										
			        		    <td width='70' class='center content_border'><%=ht.get("MNG_BR_ID")%></td>					
			        		    <td width='70' class='center content_border'>
			        		    	<%=AddUtil.subData(String.valueOf(ht.get("BUS_NM")), 3)%>        		      
			        		      <a href="javascript:parent.req_fee_start_act('문의', '[미결계약]<%=ht.get("FIRM_NM")%>-<%=ht.get("CAR_NM")%>', '<%=ht.get("BUS_ID")%>')" onMouseOver="window.status=''; return true" title='최초영업자에게 문의하기'>				
						      </a>         		      
			        		    </td>					
			        		    <td width='70' class='center content_border'><%=AddUtil.subData(String.valueOf(ht.get("BUS_AGNT_NM")), 3)%></td><!-- 영업대리인 -->
			        		    <td width='70' class='center content_border'><%=AddUtil.subData(String.valueOf(ht.get("BUS_NM2")), 3)%></td><!-- 영업담당자 -->
			        		</tr>
				 <%		}	%> 		
			      <%} else  {%>  
					       	<tr>
						       <td  colspan="14" class='center content_border'>&nbsp;</td>
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

<script type='text/javascript'>
//<!--
	parent.document.form1.size.value = "<%=count%>";
//-->
</script>
</html>