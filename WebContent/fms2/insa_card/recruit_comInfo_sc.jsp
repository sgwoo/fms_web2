<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
    
	InsaRcDatabase icd = new InsaRcDatabase();
	List<Insa_Rc_InfoBean> list=icd.selectInsaAll();
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function modifyInfo(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target=''>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width="800">
	<%	if(list.size()==0){%>
   	<tr>
		<td>-----글이 존재하지 않습니다.-----</td>
	</tr>   
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_comInfo.jsp?rc_no=0', 'cominfoList', 'left=350, top=50, width=850, height=350, scrollbars=yes, status=yes');">등록</button>
		</td>
	</tr>  		
	<%	}else{%>
	<%		for(Insa_Rc_InfoBean dto:list){%>
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_comInfo.jsp?rc_no=<%=dto.getRc_no()%>', 'cominfoList', 'left=350, top=50, width=850, height=350, scrollbars=yes, status=yes');">수정</button>
		</td>
	</tr>   
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>회사개요(<%=dto.getRc_cur_dt()%>년12월31일 현재기준)</span></td>
	  </tr>
    <tr>
    	<td class=line2></td>
    </tr>
    <tr>
        <td class="line" width='1280'>  
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   				
	        	<tr>
	        		<td class='title' width='20%'>설립일자</th>
	        		<td width='40%'>&nbsp;2000년04월19일</td>
	        		<td width='40%'></td>
	        	</tr>          
                <tr>
	        		<td class='title' width='20%'>업종</th>
	        		<td width='40%'>&nbsp;자동차대여업, 자동차임대업</td>
	        		<td width='40%'></td>
	        	</tr>  
	        	<tr>
	        		<td class='title' width='20%'>자본총계</th>
	        		<td width='40%'>&nbsp;<%=AddUtil.parseDecimal(dto.getRc_tot_capital()) %> 억원</td>
	        		<td width='40%'></td>
	        	</tr>   
	        	<tr>
	        		<td class='title' width='20%'>자산총계</th>
	        		<td width='40%'>&nbsp;<%=AddUtil.parseDecimal(dto.getRc_tot_asset())%> 억원</td>
	        		<td width='40%'></td>
	        	</tr>   
	        	<tr>
	        		<td class='title' width='20%'>메출액</th>
	        		<td width='40%'>&nbsp;<%=AddUtil.parseDecimal(dto.getRc_sales())%> 억원</td>
	        		<td width='40%'>&nbsp;<%=dto.getRc_cur_dt()%> 매출총액</td>
	        	</tr>   
	        	<tr>
	        		<td class='title' width='20%'>재직자현황</th>
	        		<td width='40%'>&nbsp;<%=dto.getRc_per_off()%> 명</td>
	        		<td width='40%'>&nbsp;10년이상 근속자(<%=dto.getRc_per_off_per()%>%)</td>
	        	</tr>   
	        	<tr>
	        		<td class='title' width='20%'>주소/연락처</th>
	        		<td width='40%' colspan="2">&nbsp;홈페이지참조</td>
	        	</tr>  
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>업계현황(<%=dto.getRc_cur_dt()%>년12월31일 현재기준)</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='1280' >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>          
                <tr>
	        		<td class='title' width='20%'>전국업체수</th>
	        		<td width='40%'>&nbsp;<%=AddUtil.parseDecimal(dto.getRc_num_com())%>개사</td>
	        		<td width='40%'>&nbsp;자동차대여사업조합 등록회원기준</td>
	        	</tr>  
	        	<tr>
	        		<td class='title' width='20%'>업계순위</th>
	        		<td width='40%'>&nbsp;<%=dto.getRc_busi_rank()%>위</td>
	        		<td width='40%'>&nbsp;전업사/보유대수기준</td>
	        	</tr>   
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	
    <%
	     }
	%>
	<!-- 
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_comInfo.jsp?rc_no=0', 'cominfoList', 'left=350, top=50, width=850, height=350, scrollbars=yes, status=yes');">추가등록</button>
		</td>
	</tr>
	 -->
	<%
	   }
	%>  

  </table>
  
</form>
</body>
</html>