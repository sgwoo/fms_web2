<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function AccidentDisp(m_id, l_cd, c_id, accid_id, accid_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.accid_id.value = accid_id;		
		fm.accid_st.value = accid_st;				
		fm.cmd.value = "u";	
		fm.target = ' d_content';	
		fm.action = '../accid_mng/accid_u_frame.jsp';			
		fm.submit();
	}
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
	//하단메뉴 이동
	function sub_in(car_comp_id, tot_su){
		var fm = document.form1;
		fm.car_comp_id.value = car_comp_id;
		fm.tot_su.value = tot_su;
		fm.action="accid_s_sc1_in.jsp";
		fm.target="i_in";		
		fm.submit();	
	}	
	
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"0":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	int size1 = 0;
	
	if(!st_dt.equals("")) 	st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt = AddUtil.replace(end_dt, "-", "");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
%>
<form name='form1' action='../accid_mng/accid_u_frame.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='accid_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='car_comp_id' value=''>
<input type='hidden' name='tot_su' value=''>
<input type='hidden' name='go_url' value='../accid_stat/accid_s_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고차량 제작사별 연식별 현황</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td class='title' width='15%'>제작사</td>
                <%for(int i=2000; i<=AddUtil.getDate2(1); i++){%>
                <td class='title'><%=i%>연식</td>
                <%	size1++;
    			}%>
                <td class='title' width="7%">계</td>
                <td class='title' width="7%">보유대수</td>
                <td class='title' width="7%">사고율</td>
              </tr>
              <%	Vector accids = as_db.getAccidStat01(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);
    				int accid_size = accids.size();
    				int su[] = new int[16];
    				float f_su[] = new float[2];
    				for (int i = 0 ; i < accid_size ; i++){
    					Hashtable accid = (Hashtable)accids.elementAt(i);%>
              <tr> 
                <td class='title'><a href="javascript:sub_in('<%=accid.get("CAR_COMP_ID")%>', '<%=accid.get("TOT_SU")%>')"><%=accid.get("NM")%></a></td>
                <td align="center"><%=accid.get("SU1")%>건</td>
                <td align="center"><%=accid.get("SU2")%>건</td>
                <td align="center"><%=accid.get("SU3")%>건</td>
                <td align="center"><%=accid.get("SU4")%>건</td>
                <td align="center"><%=accid.get("SU5")%>건</td>
                <td align="center"><%=accid.get("SU6")%>건</td>			
                <td align="center"><%=accid.get("SU7")%>건</td>		
                <td align="center"><%=accid.get("SU8")%>건</td>									
                <td align="center"><%=accid.get("SU9")%>건</td>
                <td align="center"><%=accid.get("SU10")%>건</td>
                <td align="center"><%=accid.get("SU11")%>건</td>			
                <td align="center"><%=accid.get("SU12")%>건</td>		
                <td align="center"><%=accid.get("SU13")%>건</td>									
                <td align="center"><%=accid.get("SU14")%>건</td>									
                <td align="center"><%=accid.get("TOT_SU")%>건</td>
                <td align="center"><%=accid.get("CAR_SU")%>건</td>
                <td align="center"><%=AddUtil.parseFloatCipher(Float.parseFloat(String.valueOf(accid.get("TOT_SU")))/Float.parseFloat(String.valueOf(accid.get("CAR_SU")))*100,1)%>%</td>
              </tr>
              <%			su[0]  = su[0]  + Integer.parseInt(String.valueOf(accid.get("SU1")));
    			  		su[1]  = su[1]  + Integer.parseInt(String.valueOf(accid.get("SU2")));
    			  		su[2]  = su[2]  + Integer.parseInt(String.valueOf(accid.get("SU3")));
    			  		su[3]  = su[3]  + Integer.parseInt(String.valueOf(accid.get("SU4")));
    		  			su[4]  = su[4]  + Integer.parseInt(String.valueOf(accid.get("SU5")));
    		  			su[5]  = su[5]  + Integer.parseInt(String.valueOf(accid.get("SU6")));
    		  			su[8]  = su[8]  + Integer.parseInt(String.valueOf(accid.get("SU7")));
    		  			su[9]  = su[9]  + Integer.parseInt(String.valueOf(accid.get("SU8")));
    		  			su[10]  = su[10]  + Integer.parseInt(String.valueOf(accid.get("SU9")));
    		  			su[11]  = su[11]  + Integer.parseInt(String.valueOf(accid.get("SU10")));
    		  			su[12]  = su[12]  + Integer.parseInt(String.valueOf(accid.get("SU11")));
    		  			su[13]  = su[13]  + Integer.parseInt(String.valueOf(accid.get("SU12")));
    		  			su[14]  = su[14]  + Integer.parseInt(String.valueOf(accid.get("SU13")));
    		  			su[15]  = su[15]  + Integer.parseInt(String.valueOf(accid.get("SU14")));
    			  		su[6]  = su[6]  + Integer.parseInt(String.valueOf(accid.get("TOT_SU")));
    			  		su[7]  = su[7]  + Integer.parseInt(String.valueOf(accid.get("CAR_SU")));
    					f_su[0] = f_su[0]  + Float.parseFloat(String.valueOf(accid.get("TOT_SU")));
    					f_su[1] = f_su[1]  + Float.parseFloat(String.valueOf(accid.get("CAR_SU")));
    			  }%>
              <tr> 
                <td class='title'>계</td>
                <td align="center"><%=su[0]%>건</td>
                <td align="center"><%=su[1]%>건</td>
                <td align="center"><%=su[2]%>건</td>
                <td align="center"><%=su[3]%>건</td>
                <td align="center"><%=su[4]%>건</td>
                <td align="center"><%=su[5]%>건</td>
                <td align="center"><%=su[8]%>건</td>	
                <td align="center"><%=su[9]%>건</td>				
                <td align="center"><%=su[10]%>건</td>				
                <td align="center"><%=su[11]%>건</td>				
                <td align="center"><%=su[12]%>건</td>				
                <td align="center"><%=su[13]%>건</td>				
                <td align="center"><%=su[14]%>건</td>				
                <td align="center"><%=su[15]%>건</td>				
                <td align="center"><%=su[6]%>건</td>
                <td align="center"><%=su[7]%>건</td>			
                <td align="center"><%=AddUtil.parseFloatCipher(f_su[0]/f_su[1]*100,1)%>%</td>
              </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차종별 교통사고 현황</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width='10%'>차종</td>
                    <%	Vector accids2 = as_db.getAccidStat02(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);
        				int accid_size2 = accids2.size();
        				int a=accid_size2;
        				int listsize=6;
        				if(a < listsize) listsize=a;
        				for (int i = 0 ; i < listsize ; i++){
        					Hashtable accid2 = (Hashtable)accids2.elementAt(i);%>
                    <td class='title'><%=accid2.get("CAR_NM")%></td>
                    <%	}%>
                    <td class='title' width="7%">기타차종</td>
                    <td class='title' width="7%">계</td>
                </tr>
                <tr> 
                    <td class='title'>건수</td>
                    <%	int cnt1 = 0;
        				for (int i = 0 ; i < listsize ; i++){
        					Hashtable accid2 = (Hashtable)accids2.elementAt(i);%>
                    <td align="center"><%=accid2.get("TOT_SU")%>건</td>
                    <%		cnt1  = cnt1  + Integer.parseInt(String.valueOf(accid2.get("TOT_SU")));
        				}%>
                    <td align="center"><%=su[6]-cnt1%>건</td>
                    <td align="center"><%=su[6]%>건</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><iframe src="about:blank" name="i_in" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>	
</table>
</form>
</body>
</html>
