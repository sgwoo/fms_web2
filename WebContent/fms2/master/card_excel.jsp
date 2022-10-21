<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%	MaMenuDatabase nm_db = MaMenuDatabase.getInstance(); %>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		var fm = document.form1;
		
		if(fm.filename.value == ''){			alert('파일을 선택하십시오.'); 				return; 	}
		if(fm.filename.value.indexOf('xls') == -1){	alert('엑셀파일이 아닙니다.');				return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003통합문서(*.xls)가 아닙니다.');	return;		}
		
		fm.target = '_blank';
		
		if(fm.gubun1[0].checked == true) 		fm.action = 'card_hp_excel_reg2.jsp';	
		if(fm.gubun1[1].checked == true) 		fm.action = 'card_excel_all_reg.jsp';			
		if(fm.gubun1[2].checked == true) 		fm.action = 'card_rbuydt_excel_upd.jsp';
		
		<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
		if(fm.gubun1[3].checked == true) 		fm.action = 'card_excel_all_upd_20120719.jsp';			
		<%}%>
		
				
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		fm.submit();
	}
	
//-->
</script>
</head>

<body>

  <form name='form1' action='' method='post' enctype="multipart/form-data">
    <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>법인카드일괄등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="15%" class='title'>파일</td>
                    <td>&nbsp;
    			        	  <a href="/fms2/master/card_excel_reg.jsp" target="_blank"><img src=/acar/images/center/button_igdr.gif align=absmiddle border=0></a>
    			            <!--<input type="file" name="filename" size="70">-->
                    </td>
                </tr>
                <tr>
                    <td class='title'>구분</td>
                    <td>&nbsp;
			<input type="radio" name="gubun1" value="1" >
                    	하이패스 명세서 법인카드<b>전표</b> 일괄 등록	
			<br>
			&nbsp;
			<input type="radio" name="gubun1" value="2" >
                    	법인<b>카드</b> 일괄등록	 
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	( ※ 칼럼순 : [A]카드번호('-'있는상태)	 [B]사용자구분	[C]카드사용자	 [D]한도금액 	 [E]카드관리자 성명 	[F]전표승인자 성명 )
            <br>
			&nbsp;
			<input type="radio" name="gubun1" value="4" >
                    	<b>전북카드</b> 결재기준일자 일괄 등록	 
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	( ※ 칼럼순 : [A]결재일  [B]청구조정일  [C]카드번호  [D]사용자  [E]사용일  [F]사용금액  [G]거래처  )
                    	
                    	
                    	        	
                    	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
			<br>
			<br>
			<br>
			&nbsp;
			<input type="radio" name="gubun1" value="3" >
                    	카드전표 미지급금 거래처 잘못발행분 일괄처리 (전산팀만 처리)
                    	<%}%>
                    	
                    	
                    </td>
                </tr>
            </table>
		</td>
    </tr>
    <tr>
        <td align=right>* 파일확장자 <b>*.xls</b> 인 파일만 가능합니다.</td>
    </tr>	  
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <!--
    <tr>
        <td align="right"><a href='javascript:save()'><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;		
		</td>
    </tr>
    -->
  </table>
  </form>

</body>
</html>
