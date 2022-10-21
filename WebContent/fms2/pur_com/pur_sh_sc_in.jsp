<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.* "%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 		= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String gubun7 		= request.getParameter("gubun7")	==null?"":request.getParameter("gubun7");
	String gubun8 		= request.getParameter("gubun8")	==null?"":request.getParameter("gubun8");
	String gubun9 		= request.getParameter("gubun9")	==null?"":request.getParameter("gubun9");
	String gubun10 		= request.getParameter("gubun10")	==null?"":request.getParameter("gubun10");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();	
			
	Vector vt = umd.getPurComShListNew(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, gubun8, gubun9, gubun10, st_dt, end_dt);
	int vt_size = vt.size();		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='1720'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='690' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title'>연번</td>
                    <td width='60' class='title'>예약</td>
                    <td width='80' class='title'>1순위</td>
                    <td width='60' class='title'>2순위</td>
                    <td width='60' class='title'>3순위</td>
                    <td width='100' class='title'>특판계약번호</td>
                    <td width="100" class='title'>출고영업소</td>
                    <td width='200' class='title'>차명</td>
                </tr>
            </table>
    	</td>
    	<td class='line' width='1030'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
       		<tr>
        	    <td width="300" class='title'>사양</td>
        	    <td width="220" class='title'>색상</td>
        	    <td width="80" class='title'>배정구분</td>
        	    <td width="80" class='title'>배정(예정)일</td>
                    <td width='60' class='title'>과세구분</td>
                    <td width='80' class='title'>소비자가</td>
        	    <td width='70' class='title'>D/C</td>
        	    <td width='60' class='title'>추가D/C</td>
        	    <td width='80' class='title'>계약등록일</td>
        	</tr>
	    </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>		
        <td class='line' width='690' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for (int i = 0 ; i < vt_size ; i++) {
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td width='30' align='center'><%=i+1%></td>                    
                    <td width='60' align='center'><%=ht.get("SITUATION")%></td>
                    <td width='80' align='center'><font color="#FF66FF"><%=ht.get("USER_NM")%><%=AddUtil.ChangeDate(String.valueOf(ht.get("RES_END_DT")),"MM/DD")%></font></td>
            <%
            	Vector sr = umd.getSucResList(String.valueOf(ht.get("COM_CON_NO")));
				int sr_size = sr.size();
				if (sr_size >3) {
					sr_size=3;
				}
				for (int j = 1 ; j < sr_size ; j++) {
					Hashtable sr_ht = (Hashtable)sr.elementAt(j);%>
                    <td width='60' align='center'><%=c_db.getNameById(String.valueOf(sr_ht.get("REG_ID")),"USER")%></td>
			<%}%>
			<%if (sr_size==2) {%>
					<td width='60' align='center'>&nbsp;</td>
			<%}%>
			<%if (sr_size <=1) {%>
                    <td width='60' align='center'>&nbsp;</td>
                    <td width='60' align='center'>&nbsp;</td>
			<%}%>
                    <td width='100' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("COM_CON_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("COM_CON_NO")%></a></td>
                    <td width='100' align='center'><%=ht.get("CAR_OFF_NM")%></td>
                    <td width='200' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("CAR_NM")), 30)%></span></td>        	            	                        
                </tr>
        	<%}%>
		</table>
	</td>
	<td class='line' width='1030'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%for (int i = 0 ; i < vt_size ; i++) {
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
                <tr>
                    <td width='300' align='center'><span title='<%=ht.get("OPT")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("OPT")), 45)%></span></td>
                    <td width='220' align='center'><span title='<%=ht.get("COLO")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("COLO")), 32)%></span></span></td>
                    <td width='80' align='center'><%if(String.valueOf(ht.get("DLV_ST_NM")).equals("배정")){%><font color=red><%=ht.get("DLV_ST_NM")%></font><%}else{%><%=ht.get("DLV_ST_NM")%><%}%></td>
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_ST_DT")))%></td>
                    <td width='60' align='center'><%=ht.get("PURC_GU")%></td>
                    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%></td>
                    <td width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("DC_AMT")))%></td>
                    <td width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ADD_DC_AMT")))%></td>
                    <td width='80' align='center'><%=AddUtil.ChangeDate10(String.valueOf(ht.get("REG_DT")))%></td>
                    
                </tr>
		<%}%>
	    </table>
	</td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='690' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
	</td>
	<td class='line' width='1030'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
        	    <td>&nbsp;</td>
        	</tr>
  	    </table>
	</td>
    </tr>
<%	}	%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

