<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
		
	
	int count =0;
	
	Vector vt = t_db.getCarTintMList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
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

<script language='javascript'>
<!--
	
		
//-->
</script>
</head>
<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
 <input type='hidden' name='height' id="height" value='<%=height%>'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='tint_m_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 340px;">
					<div style="width: 340px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>                      							            
					            <td width='60' class='title title_border'>연번</td>		    
							    <td width='130' class='title title_border'>용품업체</td>						
					        	<td width='90' class='title title_border'>요청등록일</td>
							    <td width="60" class='title title_border'>의뢰자</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
						
							 <colgroup>
				       			<col width="120">
				       			<col width="140">
				       			<col width="180">
				       			<col width="100">
				       			       				       					       			
				       			<col width="110">
				       			<col width="110">
				       			<col width="90">
				       			<col width="90">      
				       			<col width="100">
				       			<col width="80">			       			
				       			<col width="80">		       			
				       			<col width="70">		
				       			<col width="70">
				       			<col width="70">
				       			<col width="80">
				       						       			
				       			<col width="180">		       			
				       			<col width="90">
				       				   				       				
				       		</colgroup>
				       		
				       		<tr>
							    <td colspan="4" class='title title_border' style='height:24'>기초사항</td>
							    <td colspan="11" class='title title_border'>용품요청</td>				  
							    <td rowspan="2" width="180" class='title title_border'>고객</td>
							    <td rowspan="2" width="90" class='title title_border'>최초등록일</td>				  
							</tr>
							<tr>
							    <td width='120' class='title title_border' style='height:23'>차명</td>				  
							    <td width='140' class='title title_border'>계출번호</td>
							    <td width='180' class='title title_border'>차대번호</td>
							    <td width='100' class='title title_border'>색상</td>	
							    <td width='110' class='title title_border'>마감요청일시</td>
							    <td width='110' class='title title_border'>작업마감일시</td>
							    <td width='90' class='title title_border'>청구일자</td>
							    <td width='90' class='title title_border'>지급일자</td>
							    <td width='100' class='title title_border'>제조사</td>	
							    <td width='80' class='title title_border'>측후면썬팅</td>				      
							    <td width='80' class='title title_border'>전면썬팅</td>				      
							    <td width='70' class='title title_border'>블랙박스</td>					  
							    <td width='70' class='title title_border'>내비게이션</td>		    
							    <td width='70' class='title title_border'>기타용품</td>
							    <td width='80' class='title title_border'>이동형충전기</td>							
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
				<td style="width: 34px;">
					<div style="width: 340px;">
						<table class="inner_top_table left_fix">  
					   		 <%	if(vt_size > 0){%> 
					                <%	for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);
							%>
							<tr style="height: 25px;">
							    <td width='60' class='center content_border'><%=i+1%><%if(String.valueOf(ht.get("USE_YN")).equals("N")){%>(해지)<%}%></td>		    
							    <td width='130' class='center content_border'><span title='<%=ht.get("OFF_NM")%>'><%=ht.get("OFF_NM")%></span></td>
							    <td width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
							    <td width='60' class='center content_border'><%if(String.valueOf(ht.get("DEPT_ID")).equals("1000")){%><font color=orange><%}%><%=ht.get("USER_NM")%><%if(String.valueOf(ht.get("DEPT_ID")).equals("1000")){%></font><%}%></td>					
							</tr>
				 			<%		}%>
			         <%} else  {%>  
				           <tr>
							    <td class='center content_border'>
							        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
							        <%}else{%>등록된 데이타가 없습니다<%}%>
							    </td>
							</tr>           
				     <%}	%>
					</table>
	           	</div>            
		    </td>
		    <td>			
		     	 <div>
					<table class="inner_top_table table_layout">   		
					 <%	if(vt_size > 0){%> 	
						<%	for(int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);%>			
						<tr style="height: 25px;">
						    <%if(String.valueOf(ht.get("RENT_L_CD")).equals("")){%>
						        <td colspan="4" class='center content_border'>[대량용품]<span title='<%=ht.get("COM_MODEL_NM")%>'><%=Util.subData(String.valueOf(ht.get("COM_MODEL_NM")), 25)%></span></td>
						    <%}else{%>
						        <td width='120' class='center content_border'><span title='<%=ht.get("CAR_NM2")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM2")), 8)%></span></td>
						        <td width='140' class='center content_border'><%=ht.get("RPT_NO")%></td>
						        <td width='180' class='center content_border'><%=ht.get("CAR_NUM2")%></td>
						        <td width='100' class='center content_border'><span title='<%=ht.get("COLO")%>'><%=Util.subData(String.valueOf(ht.get("COLO")), 4)%></span></td>					
						    <%}%>
						    <td width='110' class='center content_border'><a href="javascript:parent.tint_action('<%=ht.get("DOC_NO")%>', '<%=ht.get("DOC_BIT")%>', '<%=ht.get("TINT_NO")%>', '<%=ht.get("OFF_ID")%>');"><font color=red><%=AddUtil.ChangeDate3(String.valueOf(ht.get("SUP_EST_DT")))%></font></a></td>
						    <td width='110' class='center content_border'><font color=red><%=AddUtil.ChangeDate3(String.valueOf(ht.get("SUP_DT")))%></font></td>
						    <td width='90' class='center content_border'><font color=red><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></font></td>
						    <td width='90' class='center content_border'><font color=red><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_DT")))%></font></td>
						    <td width='100' class='center content_border'><%=ht.get("COM_TINT_NM")%> <%=ht.get("COM_FILM_ST_NM")%></td>							
						    <td width='80' class='center content_border'><%if(String.valueOf(ht.get("S1_YN")).equals("Y")){%>시공<%}%></td>
						    <td width='80' class='center content_border'><%if(String.valueOf(ht.get("S2_YN")).equals("Y")){%>시공<%}%></td>
						    <td width='70' class='center content_border'><%if(String.valueOf(ht.get("B_YN")).equals("Y")){%>설치<%}%></td>
						    <td width='70' class='center content_border'><%if(String.valueOf(ht.get("N_YN")).equals("Y")){%>설치<%}%></td>
						    <td width='70' class='center content_border'><%if(String.valueOf(ht.get("E_YN")).equals("Y")){%>있음<%}%></td>
						    <td width='80' class='center content_border'><%if(String.valueOf(ht.get("EV_YN")).equals("Y")){%>설치<%}%></td>					
						    <td width='180' class='center content_border'><span title='<%=ht.get("FIRM_NM")%>' ><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 15)%></span></td>					
						    <td width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>					
						</tr>
					 <%		}	%> 		
		      <%} else  {%>  
				       	<tr>
					       <td  colspan="17" class='center content_border'>&nbsp;</td>
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

