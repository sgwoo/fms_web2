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
	
	int count =0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = new Vector();
	
	vt = a_db.getLcNoCngChkList(s_kd, t_wd, andor, gubun1, gubun2, gubun3);
	
	int cont_size = vt.size();
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
<table border="0" cellspacing="0" cellpadding="0" width='1130'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='320' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='50' class='title' style='height:51'>연번</td>
                    <td width='120' class='title'>계약번호</td>
                    <td width="150" class='title'>고객</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='810'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
                    <td colspan="2" class='title'>자동차</td>		
                    <td rowspan="2" width='90' class='title'>등록일자</td>
                    <td rowspan="2" width='90' class='title'>결재요청일</td>										
                    <td rowspan="2" width='90' class='title'>결재일자</td>																		
        		    <td colspan="4" class='title'>계약</td>
        	    </tr>
        		<tr>
        		    <td width="150" class='title'>차종</td>
        		    <td width="100" class='title'>차량번호</td>
        		    <td width='80' class='title'>대여개시일</td>					
        	        <td width='80' class='title'>계약구분</td>
        	        <td width='60' class='title'>기간</td>
        	        <td width='60' class='title'>계약담당</td>					
        		</tr>
    	    </table>
	    </td>
    </tr>
  <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='320' id='td_con' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	for(int i = 0 ; i < cont_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				%>
                <tr> 
                    <td width='50' align='center'><%=i+1%></td>
                    <td width='120' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>', '<%=ht.get("CAR_ST")%>','<%=ht.get("GUBUN")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a>
					<%if(String.valueOf(ht.get("USE_YN")).equals("Y") && nm_db.getWorkAuthUser("관리자모드",user_id)){%><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '','','<%=ht.get("CNG_ST")%>')" onMouseOver="window.status=''; return true">.</a><%}%>
					</td>
                    <td width='150' align='center'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></a></td>
                </tr>
            <%		}	%>
            </table>
	    </td>
	    <td class='line' width='810'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
        		<tr>
        		    <td width='150' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
        		    <td width='100' align='center'><a href="javascript:parent.view_car('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CAR_NO")%></a></td>					
                    <td width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                    <td width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SANCTION")))%></td>					
                    <td width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SANCTION_DATE")))%></td>
                    <td width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>										
        		    <td width='80' align='center'><%=ht.get("GUBUN")%></td>		  
        		    <td width='60' align='center'><%=ht.get("CON_MON")%></td>
        		    <td width='60' align='center'><%=ht.get("BUS_NM")%></td>
        		</tr>
<%		}	%>
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='320' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(t_wd.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='810'>			
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
	parent.document.form1.size.value = '<%=cont_size%>';
//-->
</script>
</body>
</html>


