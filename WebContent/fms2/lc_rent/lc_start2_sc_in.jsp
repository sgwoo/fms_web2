<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.cont.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
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
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = ec_db.getLcStartStat2List(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
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
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='1340'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='400' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='30' class='title' style='height:45'>연번</td>
		    <td width='50' class='title'>&nbsp;<br>구분<br>&nbsp;</td>
		    <td width='100' class='title'>계약번호</td>
		    <td width="130" class='title'>고객</td>
        	    <td width='90' class='title'>계약일자</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='940'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>		    
		    <td width='80' rowspan="2" class='title'>출고일자</td>
		    <td colspan="3" class='title'>자동차</td>			    
		    <td colspan="2" class='title'>지연대차</td>
		    <td width='160' rowspan="2" class='title'>탁송일시<br>(계약번호 연동)</td>
		    <td width='160' rowspan="2" class='title'>탁송일시<br>(차량번호 최근발생)</td>
		    <td width='70' rowspan="2" class='title'>최초영업자</td>
		</tr>
		<tr>
		    <td width='80' class='title'>차량번호</td>				
		    <td width='150' class='title'>차명</td>
		    <td width='80' class='title'>최초등록일</td>
		    <td width='80' class='title'>개시일</td>			          
		    <td width='80' class='title'>만료일</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>
	<td class='line' width='400' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
		<tr>
		    <td  width='30' align='center'><%=i+1%></td>
		    <td  width='50' align='center'><%=ht.get("CAR_GU")%></td>
		    <td  width='100' align='center'>
		        <%if(String.valueOf(ht.get("CAR_NO")).equals("")){ %>
		            <%=ht.get("RENT_L_CD")%>
		        <%}else{%>
		            <a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a>
		        <%} %>    
		    </td>
		    <td  width='130'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></td>
		    <td  width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
		</tr>
                <%}%>
	    </table>
	</td>
	<td class='line' width='940'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
		<tr>
		    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>					
		    <td  width='80' align='center'><%=ht.get("CAR_NO")%></td>
		    <td width='150'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 17)%></span></td>				
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>					
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_RENT_ST")))%></td>					
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_RENT_ET")))%></td>					
                    <td width='160' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("TO_DT")))%></td>										
                    <td width='160' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("TO_DT2")))%></td>
		    <td width='70' align='center'><%=ht.get("USER_NM")%></td>
		</tr>
                <%}%>
	    </table>
	</td>
        <%}else{%>                     
    <tr>
	<td class='line' width='400' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
			<%if(t_wd.equals("")){%>검색어를 입력하십시오.
			<%}else{%>등록된 데이타가 없습니다<%}%></td>
		</tr>
	    </table>
	</td>
	<td class='line' width='940'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%}%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
