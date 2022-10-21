<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.res_search.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String vio_dt = request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt");
	
	AddForfeitDatabase cdb = AddForfeitDatabase.getInstance();
	
	Vector vt = new Vector();
	
	if(!car_no.equals("") && !vio_dt.equals("")){
		vt = cdb.getFineSearchContList(car_no, vio_dt);
	}
	int cont_size = vt.size();
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_ts.css">
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
	
	function SetCarRent(car_st, car_mng_id,rent_mng_id,rent_l_cd, rent_st, car_no, mng_id) {
		window.opener.getContInfo(car_st, car_mng_id,rent_mng_id,rent_l_cd, rent_st, car_no, mng_id);
		self.close();	
	}
	
	function search_cont() {
		var fm = document.form1;
		
		if(fm.car_no.value == '' || fm.car_no.value.length < 7){ alert('��Ȯ�� ������ȣ�� �Է��Ͻʽÿ�'); return;} 
		if(fm.vio_dt.value == '' || fm.vio_dt.value.length < 8){ alert('��Ȯ�� �������ڸ� �Է��Ͻʽÿ�'); return;} 
		
		fm.target = 'FineSearchCont';	
		fm.action = 'fine_search_cont.jsp';
		fm.submit();	
	}

	
	function SearchFocus(arg){
		var fm = document.form1;		
		var keyValue = event.keyCode;
		if (keyValue =='13'){
			if(arg=="car_no"){
				fm.vio_dt.focus();
			}else if(arg=="vio_dt"){
				search_cont();
			}
		}
	}
	
	function view_scont(rent_mng_id, rent_l_cd, car_mng_id){
		var SUBWIN="/fms2/lc_rent/view_res.jsp?c_id="+car_mng_id;	
		window.open(SUBWIN, "VIEW_RES", "left=50, top=50, width=1050, height=600, scrollbars=yes, status=yes");
	}
	function view_cons(rent_mng_id, rent_l_cd, car_mng_id){
		var fm = document.form1;	
		var SUBWIN="/acar/fine_mng/view_cons.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&car_mng_id="+car_mng_id+"&vio_dt="+fm.vio_dt.value;	
		window.open(SUBWIN, "VIEW_CONS", "left=50, top=50, width=1150, height=800, scrollbars=yes, status=yes");
	}

</script>

<body>
<form action="search_cont.jsp" name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width=1480>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�����ȸ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td>������ȣ : <input type="text" id="car_no" name="car_no" size="10" value="<%=car_no%>" class=text style='IME-MODE: active' onKeydown="SearchFocus('car_no')">
          &nbsp;
          /
          �������� : <input type="text" name="vio_dt" value="<%=vio_dt%>" size="12" class=text onBlur='javscript:this.value = ChangeDate4(this, this.value);' onKeydown="SearchFocus('vio_dt')">
          &nbsp;
          <a href="javascript:search_cont()"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
        </td>        
    </tr>        
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뿩</span></td>        
    </tr>    
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="50">����</td>                  
                  <td class=title width="50">����</td>
                  <td class=title width="50">Ź��</td>                                    
                  <td class=title width="50">����</td>
                  <td class=title width="90">��������ȣ</td>
                  <td class=title width="90">��������ȣ</td>
                  <td class=title width="140">����</td>                  
                  <td class=title width="100">����ȣ</td>
                  <td class=title width="200">��ȣ/����</td>
                  <td class=title width="50">����</td>                  
		              <td class=title width="80">�����</td>                  
                  <td class=title width="80">�ε���</td>
                  <td class=title width="80">�뿩������</td>
                  <td class=title width="80">�뿩������</td>
                  <td class=title width="80">ȸ����</td>
                  <td class=title width="80">������</td>
                  <td class=title width="130">��������</td>
                </tr>
                <%  for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";%>
                <tr> 
                  <td <%=td_color%> align="center"><%=i+1%></td>
                  <td <%=td_color%> align="center"><a href="javascript:view_scont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='��������'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                  <td <%=td_color%> align="center"><a href="javascript:view_cons('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='Ź�ۺ���'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                  <td <%=td_color%> align="center"><%=ht.get("USE_YN_NM")%></td>
                  <td <%=td_color%> align="center"><%=ht.get("CAR_NO")%></td>
                  <td <%=td_color%> align="center"><%=ht.get("CNG_CAR_NO")%></td>
                  <td <%=td_color%> align="center"><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>                  
                  <td <%=td_color%> align="center"><a href="javascript:SetCarRent('<%=ht.get("CAR_ST")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("RENT_ST")%>','<%=ht.get("CAR_NO")%>','<%=ht.get("MNG_ID")%>')"><%=ht.get("RENT_L_CD")%></a></td>
                  <td <%=td_color%> align="center"><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 15)%></span></td>
                  <td <%=td_color%> align="center"><%=ht.get("FEE_ST")%></td>                  
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_DELI_DT")))%></td>
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RECO_DT")))%></td>
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>
                  <td <%=td_color%> align="center"><%=ht.get("CNG_CLS_ST_NM")%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%>
                  <%if(!String.valueOf(ht.get("CONT_DT")).equals("")){%>
                  <br>[<%=ht.get("CLS_ST")%>] �Ÿ����� : <%=AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT")))%>
                  <%}%>
                  <%if(!String.valueOf(ht.get("MIGR_DT")).equals("")){%>
                  <br>[<%=ht.get("CLS_ST")%>] ���������� : <%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIGR_DT")))%>
                  <%}%>
                  <%=ht.get("PREPARE_NM")%>
                  </td>
                </tr>
                <%	}%>
                <% 	if(cont_size == 0) { %>
                <tr> 
                  <td colspan=17 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
                <%	}%>
            </table>
        </td>
  </tr>
  <tr> 
        <td>&nbsp;</td>
  </tr>
  <tr>
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border="0"></a></td>
  </tr>
</table>
</form>
</body>
</html>