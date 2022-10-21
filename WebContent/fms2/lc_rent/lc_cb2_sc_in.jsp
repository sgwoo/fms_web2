<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count = 0;

	Vector vt = new Vector();

	//if(!t_wd.equals("")){
	vt = a_db.getContImportCarAmtList(s_kd, t_wd, andor, gubun1, gubun2, gubun3, st_dt, end_dt);
	//}
	int cont_size = vt.size();

	long total_amt1 = 0;
	long total_amt2 = 0;
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
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>										          		  	
		          		  	  <td width='40' class='title title_border'>연번</td>
			                  <td width='100' class='title title_border'>계약번호</td>
			                  <td width="180" class='title title_border'>고객</td>
			                  <td width='80' class='title title_border'>계약일자</td>
			                  <td width='80' class='title title_border'>대여개시일</td>                  
			                  <td width='80' class='title title_border'>신고일자</td>     
	                  
							</tr>
						</table>
					</div>
				</td>
				
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
						 <colgroup>
			             	<col width="130">
			       			<col width="100">
			       			<col width="130">
			       			<col width="80">
			       			<col width="160">		       			
			       			<col width="100"> 
			       			<col width="100"> 
			       			<col width="100"> 
			       			<col width="100">
			       			<col width="100"> 
			       					       			
			       			<col width="110">
			       			<col width="90">
			       			
			       			<col width="100">
			       			<col width="100">
			       			<col width="100">
			       				       			
			       			<col width="100">		       			
			       			<col width="100">		       			
			       			<col width="70">		       	       			
			       		</colgroup>
	       		      
						<tr>
	                          <td colspan="5" class='title title_border'>자동차</td> 
	                          <td colspan="5" class='title title_border'>차량가격</td>        		  
	        				  <td rowspan="2" width='110' class='title title_border'>통관시개별소비세<br>(교육세포함)(B)</td>
	                          <td rowspan="2" width='90' class='title title_border'>(A)-(B)</td> 	                          
	                          <td colspan="3" class='title title_border'>통관 차량가격</td>        		  
	        				  <td rowspan="2" width='100' class='title title_border'>추정통관면세가<br>견적반영가</td>
	                          <td rowspan="2" width='100' class='title title_border'>차액</td> 
	                          <td rowspan="2" width='70' class='title title_border'>출고<br>영업사원</td>       		  
		        	    </tr>
		        	    <tr>
			        		  <td width="130" class='title title_border'>제조사</td>
			        		  <td width="100" class='title title_border'>출고영업소</td>
			        		  <td width="130" class='title title_border'>차종</td>
			        		  <td width="80" class='title title_border'>차량번호</td>
			        		  <td width="160" class='title title_border'>차대번호</td>        		  
	
		        	          <td width='100' class='title title_border'>소비자가<br>(기본가격)</td>
		        	          <td width='100' class='title title_border'>소비자가<br>(옵션)</td>
		        	          <td width='100' class='title title_border'>소비자가<br>(색상)</td>
		        	          <td width='100' class='title title_border'>DC전<br>면세가</td>
		        	          <td width='100' class='title title_border'>차이(A)</td>        	          
		        		  
		        	          <td width='100' class='title title_border'>과세금액</td>
		        	          <td width='100' class='title title_border'>관세</td>
		        	          <td width='100' class='title title_border'>소계</td>        	          
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
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix">	   
				 <%if(cont_size > 0){%>
			     <%	for(int i = 0 ; i < cont_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							String td_color = "";
							if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=' is center content_border' ";
			    				%>
			                <tr> 
			                  <td <%=td_color%> width='40' class='center content_border'><%=i+1%></td>
			                  <td <%=td_color%> width='100' class='center content_border'><%=ht.get("RENT_L_CD")%></td>
			                  <td <%=td_color%> width='180' class='center content_border'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 13)%></span></td>
			                  <td <%=td_color%> width='80' class='center content_border'>
			                      <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>
			                  </td>
			                  <td <%=td_color%> width='80' class='center content_border'>
			                      <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>
			                  </td>
			                  <td <%=td_color%> width='80' class='center content_border'>
			                      <%=AddUtil.ChangeDate2(String.valueOf(ht.get("IMPORT_TAX_DT")))%>
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
						String td_color = "";
						if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=' is content_border' ";
						%>
		        		<tr>
		        		  <td <%=td_color%> width='130' class='content_border' style="text-align:center"><span title='<%=ht.get("CAR_COMP_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_COMP_NM")), 12)%></span></td>
		        		  <td <%=td_color%> width='100' class='content_border' style="text-align:center"><span title='<%=ht.get("CAR_OFF_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_OFF_NM")), 7)%></span></td>
		        		  <td <%=td_color%> width='130' class='content_border' style="text-align:center"><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
		        		  <td <%=td_color%> width='80'  class='content_border' style="text-align:center"><%=ht.get("CAR_NO")%></td>
		        		  <td <%=td_color%> width='160' class='content_border' style="text-align:center"><%=ht.get("CAR_NUM")%></td>					
		        		  
		        		  <td <%=td_color%> width='100' class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%></td>
		        		  <td <%=td_color%> width='100' class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("OPT_C_AMT")))%></td>
		        		  <td <%=td_color%> width='100' class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("CLR_C_AMT")))%></td>
		        		  <td <%=td_color%> width='100' class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>
		        		  <td <%=td_color%> width='100' class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("CAR_SPE_TAX_AMT")))%></td>
		        		  <td <%=td_color%> width='110' class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("IMPORT_SPE_TAX_AMT")))%></td>
		        		  <td <%=td_color%> width='90'  class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("CHA_SPE_TAX_AMT")))%></td>
		        		  
		        		  <td <%=td_color%> width='100' class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("IMPORT_CAR_AMT")))%></td>
		        		  <td <%=td_color%> width='100' class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("IMPORT_TAX_AMT")))%></td>
		        		  <td <%=td_color%> width='100' class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("IMPORT_TOT_AMT")))%></td>
		        		  <td <%=td_color%> width='100' class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("IMPORT_ESTI_AMT")))%></td>
		        		  <td <%=td_color%> width='100' class='content_border' style="text-align:right"><%=Util.parseDecimal(String.valueOf(ht.get("IMPORT_CHA_AMT")))%></td>   
		        		  <td <%=td_color%> width='70'  class='content_border' style="text-align:center"><span title='<%=ht.get("EMP_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("EMP_NM")), 4)%></span></td>     		  
		        		</tr>
		<%		}	%>
			 <%} else  {%>  
				       	<tr>
					       <td width="1670" colspan="18" class='center content_border'>&nbsp;</td>
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
	parent.document.form1.size.value = '<%=cont_size%>';
//-->
</script>
</body>
</html>


