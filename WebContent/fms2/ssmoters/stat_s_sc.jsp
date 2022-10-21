<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
   	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
   	int i_year = request.getParameter("st_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("st_year"));	
//	   	int i_year = 2019;  
		
	String st_year		 = Integer.toString(i_year);
	int mons 	= 5;
	
	Vector vts2 = mc_db.getSsmotersMaintList(st_year);
		
	int vt_size2 = vts2.size();			

	long t_cnt[]	 	= new long[13];
	long t_amt[]	 	= new long[13];
			 		
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	//유류대현황 리스트 이동
	function list_move(gubun3, gubun4)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun3.value = gubun3;		
		fm.gubun4.value = gubun4;	
				
		url = "/fms2/jungsan/stat_oil_mng_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}
			
			
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
<input type='hidden' name='gubun3' 	value=''>       
<input type='hidden' name='gubun4' 	value=''> 
<input type='hidden' name='st_year' 	value='<%=st_year%>'>       
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">   

<table border="0" cellspacing="0" cellpadding="0" width="1230">
    <tr>
		  <td class=line2 ></td>
	</tr>
    <tr>
	      <td class="line">
		        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	                <tr style="height: 25px;">
	                    <td width='150' rowspan="3" class='title'>년월</td>
	                    <td colspan="2" rowspan="2" class='title'>합계</td>
			            <td colspan="10" class='title'>검사업체</td>            
			        </tr>
			        <tr>
			            <td colspan="2" class='title'>성수자동차</td>
			            <td colspan="2" class='title'>차비서</td>
			            <td colspan="2" class='title'>정일현대</td>
			            <td colspan="2" class='title'>영등포검사소</td>
			            <td colspan="2" class='title'>협신자동차</td>			               
                    </tr>
           			<tr align="center"> 
			            <td width=80 class=title>건수</td>
			            <td width=100 class=title>금액</td>
					  <%for (int j = 0 ; j < mons ; j++){%>
			            <td width=80 class=title>건수</td>
			            <td width=100 class=title>금액</td>
					  <%}%>
			         </tr>
       
	<%	if(vt_size2 > 0){%>  
	   <%	for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
			     	for (int j = 0 ; j < mons+1 ; j++){
					    t_cnt[j] = t_cnt[j] +  Util.parseLong(String.valueOf(ht.get("CNT"+(j))));
					    t_amt[j] = t_amt[j] +  Util.parseLong(String.valueOf(ht.get("AMT"+(j))));                        
				  	}		
						
		%>	
					<tr>			           
			            <td align="center"><%=ht.get("YM")%></td>
			            </td>                
			            <%	for (int j = 0 ; j < mons+1 ; j++){%>
			            <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT"+(j))))%></td>
			            <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT"+(j))))%></td>                        
					   <%	}%>
			         </tr>
        
<%		} %>			  
					<tr> 
					  <td align="center" class=title>합계</td>
					   <%	for (int j = 0 ; j < mons+1 ; j++){%>
				            <td align="right" class=title style='text-align:right'><%=Util.parseDecimal(t_cnt[j])%></td>
				            <td align="right" class=title style='text-align:right'><%=Util.parseDecimal(t_amt[j])%></td>                        
					   <%	}%>
					</tr>

 <% } else {%> 
			      <tr>	
					 <td width="1230" colspan="13" align='center'>&nbsp;등록된 데이타가 없습니다</td>					
				
			 	 </tr>
  
<% 	}%> 
	     </table>
	    </td>    
	  </tr>
  </table>
</form>
</body>
</html>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
