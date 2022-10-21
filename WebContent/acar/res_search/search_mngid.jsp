<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String s_brch_id = request.getParameter("s_brch_id")==null?"":request.getParameter("s_brch_id");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
	Vector vt = rs_db.getSearchMngIdList(s_brch_id);
	int vt_size = vt.size();
	
	//보유차정보
	Hashtable cont = a_db.getContViewUseYCarCase(c_id);
	
	
	//20121116 차량대수순보다는 순차적인 배정이 필요
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function select(mng_id,mng_nm){		
		var ofm = opener.document.form1;
		ofm.mng_id.value = mng_id;
		ofm.mng_nm.value = mng_nm;
		self.close();			
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > <span class=style5>관리담당자 검색</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보유차 정보</span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td width='20%' class='title'>계약번호</td>
                    <td colspan="3">&nbsp;<%=cont.get("RENT_L_CD")%></td>
                  </tr>                  
                  <tr> 
                    <td width='20%' class='title'>영업담당자</td>
                    <td width='30%'>&nbsp;<%=c_db.getNameById(String.valueOf(cont.get("BUS_ID2")),"USER")%></td>                    
                    <td width='20%' class='title'>관리담당자</td>
                    <td width='30%'>&nbsp;<a href="javascript:select('<%= cont.get("MNG_ID")%>','<%=c_db.getNameById(String.valueOf(cont.get("MNG_ID")),"USER")%>')" onMouseOver="window.status=''; return true"><%=c_db.getNameById(String.valueOf(cont.get("MNG_ID")),"USER")%></a></td>                    
                  </tr>                  
                </table>
	    </td>	    
	</tr>    
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업소별 관리업무직원 월렌트 관리대수 현황</span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td width='10%' class='title'>연번</td>
                    <td width='45%' class='title'>담당자</td>
                    <td width='45%' class='title'>월렌트 관리 대수</td>                    
                  </tr>
                  <%for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><a href="javascript:select('<%= ht.get("USER_ID")%>','<%= ht.get("USER_NM")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM")%> <%=ht.get("USER_POS")%></a></td>                    
                    <td align='center'><%=ht.get("CNT")%></td>
                  </tr>    			
    		  <%}%>	
                </table>
	    </td>	    
	</tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td>* 타지점의 사원리스트를 조회하려면 이창을 닫고, 월렌트 등록화면에서 영업소를 변경후 다시 조회하세요.</td>
    </tr>    	
    <tr>
        <td>* 1순위 : 월렌트 기존고객 관리담당자</td>
    </tr>    	
    <tr>
        <td>* 2순위 : 보유차의 관리담당자</td>
    </tr>    	
    <tr>
        <td>* 3순위 : 상단 리스트에서 관리대수가 적은 직원을 우선으로 선택</td>
    </tr>    	
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
