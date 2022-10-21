<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*, acar.off_anc.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	OffAncDatabase oad = OffAncDatabase.getInstance();

	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	
	String car_comp_nm 	= c_db.getNameById(car_comp_id,"CAR_COM");	
	String car_nm 		= c_db.getNameById(car_comp_id+""+code,"CAR_MNG");
	String car_nm2 		= c_db.getNameById(car_comp_id+""+code,"CAR_MNG_AB");
	String refer_nm 	= c_db.getNameById(car_comp_id+""+code,"REFER_NM");
	int s_day = 90;
	
	String car_comp_nm2 = AddUtil.replace(car_comp_nm,"자동차",""); 
	car_comp_nm2 = AddUtil.replace(car_comp_nm2,"(주)","");
	
	if(car_comp_nm2.equals("메르세데스-벤츠")){
		car_comp_nm2 = "벤츠";
	}
	
	//0001~0005 국산차
	//0006~     수입차
	Vector vt1 = oad.getEstiBbsList("1", car_comp_id, code, car_comp_nm2, car_nm, car_nm2, refer_nm, s_day, "");		
	int vt1_size = vt1.size();
	
	//제조사
	Vector vt2 = oad.getEstiBbsList("2", car_comp_id, code, car_comp_nm2, car_nm, car_nm2, refer_nm, s_day, "");		
	int vt2_size = vt2.size();
	
	//차종
	Vector vt3 = oad.getEstiBbsList("3", car_comp_id, code, car_comp_nm2, car_nm, car_nm2, refer_nm, s_day, "");		
	int vt3_size = vt3.size();
	
%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<script language='javascript'>
<!--
	function Anc_Open(bbs_id,acar_id){
		var SUBWIN="/fms2/off_anc/anc_se_c.jsp?bbs_id="+bbs_id+"&acar_id="+acar_id;	
		window.open(SUBWIN, "AncDisp", "left=100, top=50, width=1024, height=800, scrollbars=yes");
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name="car_comp_id" value="<%=car_comp_id%>">
<input type='hidden' name="code" value="<%=code%>">
<input type='hidden' name="mode" value="view">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>해당차종 공지사항 : <%=car_comp_nm%> <%=car_nm%></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>※ 노란색 라인은 공지유효기간이 아직 남아 있는 건입니다.</td>
    </tr>
    <tr>
        <td>※ 단산은 빨간색으로 강조하였습니다. </td>
    </tr>

    <%if(vt3_size >0){ %>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_nm %> (제목or내용 : 
	    <%if(car_nm2.equals("")){%><%=car_nm %><%}%>
	    <%if(!car_nm2.equals("") ){%><%=car_nm2 %><%}%>
	    <%if(!refer_nm.equals("")){%>|<%=refer_nm %><%}%>, 최근 3개월)</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>			
                <tr>                     
                    <td width=5% class=title>연번</td>                    
                    <td width=10% class=title>카테고리</td>
                    <td width=55% class=title>제목</td>
                    <td width=10% class=title>등록자</td>
                    <td width=10% class=title>등록일</td>
                    <td width=10% class=title>만료일</td>
    		    </tr>     
    		    <%for(int i = 0 ; i < vt3_size ; i++){
					Hashtable ht = (Hashtable)vt3.elementAt(i);
					String td_color = "";
					if(String.valueOf(ht.get("SEQ")).equals("0")) td_color = " class='is' ";
				%>
                <tr>                     
                    <td <%=td_color%> align=center><%=i+1%></td>                    
                    <td <%=td_color%> align=center><%=ht.get("BBS_ST")%></td>
                    <td <%=td_color%>>&nbsp;<a href="javascript:Anc_Open('<%=ht.get("BBS_ID")%>','<%=ck_acar_id%>')" id="bbs_<%=ht.get("BBS_ID")%>" ><span><%=ht.get("TITLE")%></span></a></td>
                    <td <%=td_color%> align=center><%=ht.get("USER_NM")%></td>
                    <td <%=td_color%> align=center><%=AddUtil.ChangeDate3(ht.get("REG_DT")+"")%></td>
                    <td <%=td_color%> align=center><%=AddUtil.ChangeDate3(ht.get("EXP_DT")+"")%></td>
    		    </tr>     					     
				<%} %>	    
    		</table>
	    </td>
	</tr> 
	<%} %>

    <tr>
        <td class=h></td>
    </tr>
    <%if(vt2_size >0){ %>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_comp_nm2 %> (제목 : <%=car_comp_nm2 %>, 최근 3개월)</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>			
                <tr>                     
                    <td width=5% class=title>연번</td>                    
                    <td width=10% class=title>카테고리</td>
                    <td width=55% class=title>제목</td>
                    <td width=10% class=title>등록자</td>
                    <td width=10% class=title>등록일</td>
                    <td width=10% class=title>만료일</td>
    		    </tr>     
    		    <%for(int i = 0 ; i < vt2_size ; i++){
					Hashtable ht = (Hashtable)vt2.elementAt(i);
					String td_color = "";
					if(String.valueOf(ht.get("SEQ")).equals("0")) td_color = " class='is' ";
				%>
                <tr>                     
                    <td <%=td_color%> align=center><%=i+1%></td>                    
                    <td <%=td_color%> align=center><%=ht.get("BBS_ST")%></td>
                    <td <%=td_color%>>&nbsp;<a href="javascript:Anc_Open('<%=ht.get("BBS_ID")%>','<%=ck_acar_id%>')" id="bbs_<%=ht.get("BBS_ID")%>" ><span><%=ht.get("TITLE")%></span></a></td>
                    <td <%=td_color%> align=center><%=ht.get("USER_NM")%></td>
                    <td <%=td_color%> align=center><%=AddUtil.ChangeDate3(ht.get("REG_DT")+"")%></td>
                    <td <%=td_color%> align=center><%=AddUtil.ChangeDate3(ht.get("EXP_DT")+"")%></td>
    		    </tr>     					     
				<%} %>	    
    		</table>
	    </td>
	</tr> 
	<%} %>
    <tr>
        <td class=h></td>
    </tr>	
    <%if(vt1_size >0){ %>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(AddUtil.parseInt(car_comp_id) > 5 ) { %>수입차<%}else{%>국산차<%}%> (공지기간 유효분)</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>			
                <tr>                     
                    <td width=5% class=title>연번</td>                    
                    <td width=10% class=title>카테고리</td>
                    <td width=55% class=title>제목</td>
                    <td width=10% class=title>등록자</td>
                    <td width=10% class=title>등록일</td>
                    <td width=10% class=title>만료일</td>
    		    </tr>     
    		    <%for(int i = 0 ; i < vt1_size ; i++){
					Hashtable ht = (Hashtable)vt1.elementAt(i);
					String td_color = "";
					if(String.valueOf(ht.get("SEQ")).equals("0")) td_color = " class='is' ";
				%>
                <tr>                     
                    <td <%=td_color%> align=center><%=i+1%></td>                    
                    <td <%=td_color%> align=center><%=ht.get("BBS_ST")%></td>
                    <td <%=td_color%>>&nbsp;<a href="javascript:Anc_Open('<%=ht.get("BBS_ID")%>','<%=ck_acar_id%>')" id="bbs_<%=ht.get("BBS_ID")%>" ><span>
                    <%if(String.valueOf(ht.get("END_ST")).equals("1") || String.valueOf(ht.get("END_ST")).equals("2")){%>
                    <font color=red><%=ht.get("TITLE")%></font>
                    <%}else{ %> 
                    <%=ht.get("TITLE")%>
                    <%} %>
                    </span></a></td>
                    <td <%=td_color%> align=center><%=ht.get("USER_NM")%></td>
                    <td <%=td_color%> align=center><%=AddUtil.ChangeDate3(ht.get("REG_DT")+"")%></td>
                    <td <%=td_color%> align=center><%=AddUtil.ChangeDate3(ht.get("EXP_DT")+"")%></td>
    		    </tr>     					     
				<%} %>	    
    		</table>
	    </td>
	</tr> 
	<%} %>    
    <tr>
        <td class=h></td>
    </tr>            
    <tr>
        <td align="right"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr> 
</table>
</form>
<script language="JavaScript">
<!--
$("span:contains('단산')").css({color:"red"});
//-->
</script>
</center> 
</body>
</html>
