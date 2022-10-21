<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	//�˻�����
 	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String s_dept = request.getParameter("s_dept")==null?"":request.getParameter("s_dept");
	String s_user = request.getParameter("s_user")==null?"":request.getParameter("s_user");
	String s_mng_way = request.getParameter("s_mng_way")==null?"":request.getParameter("s_mng_way");
	String s_mng_st = request.getParameter("s_mng_st")==null?"":request.getParameter("s_mng_st");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	
	
	Hashtable ht = ad_db.getStatMakerCarAll2(gubun2, gubun3, gubun4, st_dt, end_dt);
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.height_td {height:33px;}
select {
	width: 104px !important;
}
.input {
	height: 24px !important;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	//�˻��ϱ�
	function search(){
		var fm = document.form1;	
		fm.action = "./stat_maker_car_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function show_maker(arg){
		
		fm =document.form1;
		
		if(arg != 'all'){
			if(fm.gubun2[0].checked == true){
				fm.action = "./stat_maker_car_mon_sc.jsp?maker="+arg;
				
				if(arg == '0000') fm.action = "./stat_maker_car_sc3.jsp?maker="+arg;
			}else{
				fm.action = "./stat_maker_car_sc2.jsp?maker="+arg;		
				
				if(arg == '0000') fm.action = "./stat_maker_car_sc3.jsp?maker="+arg;		
				
				var dt1 = fm.st_dt.value.substr(0,4);
				var dt2 = fm.end_dt.value.substr(0,4);
				
				if(dt1 != '' && dt1 == dt2){
					fm.action = "./stat_maker_car_mon_sc.jsp?maker="+arg;			
					if(arg == '0000') fm.action = "./stat_maker_car_sc3.jsp?maker="+arg;
				}
			}
		}else{
			 fm.action = "./stat_maker_car_total_sc.jsp";
		}
		

			
		fm.target = "c_foot";
		fm.submit();
	} 
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' action='stat_maker_car_frame.jsp' target='d_content'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>   
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan="7" >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td class=navigation>&nbsp;<span class=style1>��Ȳ �� ��� > �������� > <span class=style5>�����纰������Ȳ</span></span></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td width="60px">&nbsp;
        	<label><i class="fa fa-check-circle"></i> �뵵 </label>
        </td>
        <td width="130px">
			<select name="gubun3" class="select">
              <option value=""  <%if(gubun3.equals("")){%>selected<%}%>>��ü</option>
              <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>������</option>
              <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>������</option>
            </select>
		</td>
		<td width="90px">&nbsp;
        	<label><i class="fa fa-check-circle"></i> �Ⱓ���� </label>
        </td>
        <td width="120px">
			<select name="gubun4" class="select">
              <option value="1" <%if(gubun4.equals("1")){%>selected<%}%>>���ʵ����</option>
              <option value="2" <%if(gubun4.equals("2")){%>selected<%}%>>�������</option>
              <option value="3" <%if(gubun4.equals("3")){%>selected<%}%>>�������</option>
            </select>
		</td>
        <td width="*">
			<input type="radio" name="gubun2" value="2" <%if(gubun2.equals("2"))%>checked<%%>>
			��� 
			<input type="radio" name="gubun2" value="3" <%if(gubun2.equals("3"))%>checked<%%>>
			��ȸ�Ⱓ&nbsp;&nbsp; 
			<input class="input" type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
			~ 
			<input class="input" type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text"> 
			&nbsp;<input type="button" class="button" value="�˻�" onclick="javascript:search();">
		<td>
		<td width="100px">
			&nbsp;<input type="button" class="button btn-submit" value="�����纰 ��Ȳ ���պ���" style="float: right;" onClick="javascript:show_maker('all');">
        </td>
    </tr>	
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td colspan="2" class="title">����</td>
                    <td colspan="2" class="title">���</td>
                    <td colspan="2" class="title">����</td>
                    <td colspan="2" class="title">�ѱ�GM</td>
                    <td colspan="2" class="title">�ֿ�</td>
                    <td colspan="2" class="title">��Ÿ</td>
                    <td class="title">�հ�</td>
                </tr>
                <tr> 
                    <td width="7%" class="title">���</td>
                    <td width="7%" class="title">������</td>
                    <td width="7%" class="title">���</td>
                    <td width="7%" class="title">������</td>
                    <td width="7%" class="title">���</td>
                    <td width="7%" class="title">������</td>
                    <td width="7%" class="title">���</td>
                    <td width="7%" class="title">������</td>
                    <td width="7%" class="title">���</td>
                    <td width="7%" class="title">������</td>
                    <td width="7%" class="title">���</td>
                    <td width="7%" class="title">������</td>
                    <td width="12%" class="title">���</td>
                </tr>
                <tr> 
                    <td align="center"><a href="javascript:show_maker('0001')"><%= ht.get("H") %>��</a></td>
                    <td align="center"><a href="javascript:show_maker('0001')"><%= ht.get("HP") %>%</a></td>
                    <td align="center"><a href="javascript:show_maker('0002')"><%= ht.get("K") %>��</a></td>
                    <td align="center"><a href="javascript:show_maker('0002')"><%= ht.get("KP") %>%</a></td>
                    <td align="center"><a href="javascript:show_maker('0003')"><%= ht.get("R") %>��</a></td>
                    <td align="center"><a href="javascript:show_maker('0003')"><%= ht.get("RP") %>%</a></td>
                    <td align="center"><a href="javascript:show_maker('0004')"><%= ht.get("G") %>��</a></td>
                    <td align="center"><a href="javascript:show_maker('0004')"><%= ht.get("GP") %>%</a></td>
                    <td align="center"><a href="javascript:show_maker('0005')"><%= ht.get("S") %>��</a></td>
                    <td align="center"><a href="javascript:show_maker('0005')"><%= ht.get("SP") %>%</a></td>
                    <td align="center"><a href="javascript:show_maker('0000')"><%= ht.get("E") %>��</a></td>
                    <td align="center"><a href="javascript:show_maker('0000')"><%= ht.get("EP") %>%</a></td>
                    <td align="center"><a href="javascript:show_maker('total')"><%= ht.get("TOTAL") %></a></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
